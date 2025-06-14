const express = require('express');
const rizzhomaController = require('../controllers/rizzhomaController');
const router = express.Router();

router.post('/', rizzhomaController.createUser);
router.post('/checkEmail', rizzhomaController.ambilUserByEmail);
router.post('/verifyPassword', rizzhomaController.logIn);
router.post('/getDataUser', rizzhomaController.ambilUserById);
router.post('/transaction', rizzhomaController.transaction);
router.post('/ambilTransaction', rizzhomaController.ambilTransaction);
router.get('/getDonations',rizzhomaController.ambilDonasi);
router.post('/getDataDonation', rizzhomaController.ambilDonasiById);
router.post('/createTransaction', rizzhomaController.createTransaction);
router.post('/updateAmount', rizzhomaController.updateAmount);

router.get('/pohon', rizzhomaController.ambilSemuaPohon);

module.exports = router;
