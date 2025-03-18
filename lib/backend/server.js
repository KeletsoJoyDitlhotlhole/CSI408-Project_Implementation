const express = require('express');
const { Pool } = require('pg');  // Import the PostgreSQL client
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken');
const jwksClient = require('jwks-rsa');
const nodemailer = require('nodemailer');
const crypto = require('crypto');
const bcrypt = require('bcryptjs');

// Create Express app
const app = express();
app.use(bodyParser.json()); // Parse JSON requests

// PostgreSQL connection details
const pool = new Pool({
  user: 'postgres',              // Your PostgreSQL username
  host: 'localhost',             // Host of your database (localhost if running locally)
  database: 'Medication Compliance Tool',  // Database name
  password: 'admin',             // Password for your PostgreSQL user
  port: 5432,                    // Default PostgreSQL port
});

// Keycloak Config
const keycloakIssuer = 'http://localhost:8080/realms/csi408-medication-compliance-tool';
const client = jwksClient({
  jwksUri: `${keycloakIssuer}/protocol/openid-connect/certs`,
});

// Function to get public key from Keycloak
function getKey(header, callback) {
  client.getSigningKey(header.kid, (err, key) => {
    const signingKey = key.publicKey || key.rsaPublicKey;
    callback(null, signingKey);
  });
}

// Verify token middleware
function verifyToken(req, res, next) {
  const token = req.headers.authorization?.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  jwt.verify(token, getKey, { issuer: keycloakIssuer }, (err, decoded) => {
    if (err) {
      return res.status(401).json({ error: 'Invalid token' });
    }

    req.user = decoded;  // Attach user information to the request object
    next();
  });
}

// Connect to PostgreSQL and check if the connection is successful
pool.connect((err, client, release) => {
  if (err) {
    console.error('Error connecting to the database:', err.stack);
    return;
  }
  console.log('Connected to the database');
  release();
});

// ** Existing Endpoints **

// Generate a reset password token and send it to the user's email
app.post('/reset-password-request', (req, res) => {
  const { email } = req.body;

  // Check if the email exists in the database
  pool.query('SELECT * FROM users WHERE email = $1', [email], (err, results) => {
    if (err) {
      console.error('Error checking email', err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }

    if (results.rows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    const user = results.rows[0];
    const resetToken = crypto.randomBytes(20).toString('hex');
    const resetTokenExpiry = new Date(Date.now() + 3600000); // 1 hour expiry

    // Update user record with reset token and expiry
    pool.query('UPDATE users SET resetToken = $1, resetTokenExpiry = $2 WHERE email = $3',
      [resetToken, resetTokenExpiry, email],
      (err) => {
        if (err) {
          console.error('Error updating reset token', err);
          return res.status(500).json({ error: 'Internal Server Error' });
        }

        // Send email with reset password link
        const transporter = nodemailer.createTransport({
          service: 'gmail',
          auth: {
            user: 'your-email@gmail.com',
            pass: 'your-email-password',
          },
        });

        const resetLink = `http://localhost:3000/reset-password/${resetToken}`;
        transporter.sendMail({
          to: email,
          subject: 'Password Reset Request',
          text: `You requested a password reset. Please click the link below to reset your password: ${resetLink}`,
        }, (error, info) => {
          if (error) {
            console.error('Error sending email', error);
            return res.status(500).json({ error: 'Error sending email' });
          }
          res.status(200).json({ message: 'Password reset link sent to email' });
        });
      }
    );
  });
});

// Reset password endpoint
app.post('/reset-password/:token', (req, res) => {
  const { token } = req.params;
  const { newPassword } = req.body;

  // Check if the reset token is valid
  pool.query('SELECT * FROM users WHERE resetToken = $1 AND resetTokenExpiry > $2',
    [token, new Date()],
    (err, results) => {
      if (err) {
        console.error('Error fetching user by token', err);
        return res.status(500).json({ error: 'Internal Server Error' });
      }

      if (results.rows.length === 0) {
        return res.status(400).json({ error: 'Invalid or expired token' });
      }

      const user = results.rows[0];

      // Hash the new password
      bcrypt.hash(newPassword, 10, (err, hashedPassword) => {
        if (err) {
          console.error('Error hashing password', err);
          return res.status(500).json({ error: 'Internal Server Error' });
        }

        // Update password and clear reset token
        pool.query('UPDATE users SET password = $1, resetToken = NULL, resetTokenExpiry = NULL WHERE resetToken = $2',
          [hashedPassword, token],
          (err) => {
            if (err) {
              console.error('Error updating password', err);
              return res.status(500).json({ error: 'Internal Server Error' });
            }

            res.status(200).json({ message: 'Password successfully reset' });
          }
        );
      });
    }
  );
});

// Save Patient Endpoint (with Keycloak token verification)
app.post('/save-patient', verifyToken, (req, res) => {
  const { Patient_ID, Patient_Name, Patient_Surname, Patient_DoB, Patient_Gender, Patient_PhoneNumber } = req.body;

  if (!Patient_ID || !Patient_Name || !Patient_Surname || !Patient_DoB || !Patient_Gender || !Patient_PhoneNumber) {
    return res.status(400).json({ error: 'All fields are required' });
  }

  const query = `INSERT INTO Patient (Patient_ID, Patient_Name, Patient_Surname, Patient_DoB, Patient_Gender, Patient_PhoneNumber)
                 VALUES ($1, $2, $3, $4, $5, $6)`;

  pool.query(query, [Patient_ID, Patient_Name, Patient_Surname, Patient_DoB, Patient_Gender, Patient_PhoneNumber], (err, results) => {
    if (err) {
      console.error('Error inserting data', err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }

    res.status(200).send({ message: 'Patient data saved successfully' });
  });
});

// Protected Route to Fetch Patient Data (only the logged-in patient's data)
app.get('/patients', verifyToken, (req, res) => {
  const { patientId } = req.user; // Get patientId from JWT (logged-in user's data)
  
  pool.query('SELECT * FROM Patient WHERE Patient_ID = $1', [patientId], (err, results) => {
    if (err) {
      console.error('Error fetching data:', err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }
    res.status(200).json(results.rows);
  });
});

// ** New Endpoints **

// Fetch Medication Schedules for the Logged-in Patient (based on patientId)
app.get('/medication-schedules', verifyToken, (req, res) => {
  const { patientId } = req.user; // Get patientId from JWT (logged-in user's data)

  pool.query(
    'SELECT * FROM MedicationSchedule WHERE Patient_ID = $1',
    [patientId],
    (err, results) => {
      if (err) {
        console.error('Error fetching medication schedules:', err);
        return res.status(500).json({ error: 'Internal Server Error' });
      }
      res.status(200).json(results.rows);
    }
  );
});

// Save a Medication Log (for the logged-in patient's medication)
app.post('/save-medication-log', verifyToken, (req, res) => {
  const { scheduleId, isLogged } = req.body;

  if (!scheduleId || isLogged === undefined) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  const query = `
    UPDATE MedicationSchedule
    SET IsTaken = $1
    WHERE Schedule_ID = $2 AND Patient_ID = $3
  `;

  pool.query(query, [isLogged ? 'Yes' : 'No', scheduleId, req.user.patientId], (err) => {
    if (err) {
      console.error('Error updating medication log:', err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }

    res.status(200).json({ message: 'Medication log updated successfully' });
  });
});

// Get all prescriptions for the specific logged-in patient
app.get('/prescriptions', verifyToken, (req, res) => {
  const { patientId } = req.user; // Get patientId from JWT (logged-in user's data)

  pool.query(
    'SELECT * FROM Prescription WHERE Patient_ID = $1',
    [patientId],
    (err, results) => {
      if (err) {
        console.error('Error fetching prescriptions:', err);
        return res.status(500).json({ error: 'Internal Server Error' });
      }
      res.status(200).json(results.rows);
    }
  );
});

// Get Refill Reminders for the logged-in patient
app.get('/refill-reminders', verifyToken, (req, res) => {
  const { patientId } = req.user; // Get patientId from JWT (logged-in user's data)

  pool.query(
    `SELECT p.Refill_Date, m.Med_Name
     FROM Prescription p
     JOIN Medication m ON p.Med_ID = m.Med_ID
     WHERE p.Patient_ID = $1 AND p.Refill_Date IS NOT NULL`,
    [patientId],
    (err, results) => {
      if (err) {
        console.error('Error fetching refill reminders:', err);
        return res.status(500).json({ error: 'Internal Server Error' });
      }
      res.status(200).json(results.rows);
    }
  );
});

// Start the server
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
