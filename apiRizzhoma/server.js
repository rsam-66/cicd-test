const express = require('express');
const multer = require('multer');
const bodyParser = require('body-parser');
const app = express();
require('dotenv').config();
const cors = require('cors');
const rizzhomaRoutes = require('./src/routes/rizzhomaRoutes');
const uploadRoutes = require('./src/routes/uploadRoutes');

// Middleware for CORS
app.use(cors());

app.use('/uploads', express.static('uploads'));

// Middleware to handle large JSON and form-data payloads
app.use(bodyParser.json({ limit: '10mb' }));
app.use(bodyParser.urlencoded({ limit: '10mb', extended: true }));

// Define your routes
app.use('/api', rizzhomaRoutes);
app.use('/api', uploadRoutes);

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server berjalan di http://0.0.0.0:${PORT}`);
});
