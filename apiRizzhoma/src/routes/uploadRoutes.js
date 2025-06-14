const express = require('express');
const multer = require('multer');
const path = require('path');
const db = require('../config/database');

const router = express.Router();

// Setup storage Multer
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    const uniqueName = Date.now() + '-' + Math.round(Math.random() * 1E9) + path.extname(file.originalname);
    cb(null, uniqueName);
  }
});

const upload = multer({ storage: storage });

// Endpoint upload image
router.post('/uploadImage', upload.single('image'), (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: 'No file uploaded.' });
  }
  const imageUrl = `${req.protocol}://${req.get('host')}/uploads/${req.file.filename}`;
  res.status(200).json({ status: 'success', imageUrl: imageUrl });
});

router.post('/updateProfile', (req, res) => {
  const { userID, profileImageUrl } = req.body;

  if (!userID || !profileImageUrl) {
    return res.status(400).json({ error: 'Missing userID or profileImageUrl.' });
  }

  db.query(
    'UPDATE appuser SET profileImageUrl = ? WHERE userID = ?',
    [profileImageUrl, userID],
    (err, result) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ error: 'Failed to update profile.' });
      }

      res.status(200).json({
        status: 'success',
        message: 'Profile updated successfully.',
      });
    }
  );
});


module.exports = router;