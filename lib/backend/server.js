const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const jwt = require('jsonwebtoken');
const jwksClient = require('jwks-rsa');

// Create Express app
const app = express();
app.use(bodyParser.json()); // Parse JSON requests

// Create MySQL connection
const db = mysql.createConnection({
  host: 'localhost',  // MySQL database host
  user: 'root',       // MySQL username
  password: 'yourpassword', // MySQL password
  database: 'medication_compliance_tool' // MySQL database name
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
