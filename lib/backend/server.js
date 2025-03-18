const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken');
const jwksClient = require('jwks-rsa');
const nodemailer = require('nodemailer');
const crypto = require('crypto');
const bcrypt = require('bcryptjs');

// Create Express app
const app = express();
app.use(bodyParser.json()); // Parse JSON requests

// Create MySQL connection
const db = mysql.createConnection({
  host: 'localhost',  // MySQL database host
  user: 'postgres',       // MySQL username
  database: 'Medication Compliance Tool', // MySQL database name
  password: 'admin',
  port: 5432, // MySQL
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

    req.user = decoded;
    next();
  });
}

// Connect to the MySQL database
db.connect((err) => {
  if (err) {
    console.error('Error connecting to the database:', err);
    return;
  }
  console.log('Connected to the database');
});

// Generate a reset password token and send it to the user's email
app.post('/reset-password-request', (req, res) => {
  const { email } = req.body;

  // Check if the email exists in the database
  db.query('SELECT * FROM users WHERE email = ?', [email], (err, results) => {
    if (err) {
      console.error('Error checking email', err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }

    if (results.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    const user = results[0];
    const resetToken = crypto.randomBytes(20).toString('hex');
    const resetTokenExpiry = new Date(Date.now() + 3600000); // 1 hour expiry

    // Update user record with reset token and expiry
    db.query('UPDATE users SET resetToken = ?, resetTokenExpiry = ? WHERE email = ?',
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
  db.query('SELECT * FROM users WHERE resetToken = ? AND resetTokenExpiry > ?',
    [token, new Date()],
    (err, results) => {
      if (err) {
        console.error('Error fetching user by token', err);
        return res.status(500).json({ error: 'Internal Server Error' });
      }

      if (results.length === 0) {
        return res.status(400).json({ error: 'Invalid or expired token' });
      }

      const user = results[0];

      // Hash the new password
      bcrypt.hash(newPassword, 10, (err, hashedPassword) => {
        if (err) {
          console.error('Error hashing password', err);
          return res.status(500).json({ error: 'Internal Server Error' });
        }

        // Update password and clear reset token
        db.query('UPDATE users SET password = ?, resetToken = NULL, resetTokenExpiry = NULL WHERE resetToken = ?',
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
                 VALUES (?, ?, ?, ?, ?, ?)`;

  db.execute(query, [Patient_ID, Patient_Name, Patient_Surname, Patient_DoB, Patient_Gender, Patient_PhoneNumber], (err, results) => {
    if (err) {
      console.error('Error inserting data', err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }

    res.status(200).send({ message: 'Patient data saved successfully' });
  });
});

// Protected Route to Fetch Patient Data
app.get('/patients', verifyToken, (req, res) => {
  db.query('SELECT * FROM Patient', (err, results) => {
    if (err) {
      console.error('Error fetching data:', err);
      return res.status(500).json({ error: 'Internal Server Error' });
    }
    res.status(200).json(results);
  });
});

// Start the server
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
