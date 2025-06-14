const express = require('express');
const perusahaanController = require('../controllers/perusahaanController');
const router = express.Router();

router.post('/daftarPerusahaan', perusahaanController.createPerusahaan);
router.post('/checkEmailPerusahaan', perusahaanController.ambilPerusahaanByEmail);
router.post('/storePerusahaan', perusahaanController.createPerusahaan);
router.post('/verifyPasswordPerusahaan',perusahaanController.logIn);
router.post('/getDataPerusahaan', perusahaanController.ambilPerusahaanById);
router.post('/uploadPekerjaan', perusahaanController.uploadPekerjaan);
router.post('/getPekerjaan', perusahaanController.getPekerjaan);
router.post('/updatePerusahaan', perusahaanController.updatePerusahaan);
router.get('/getPerusahaanAndPekerjaan', perusahaanController.getPerusahaanAndPekerjaan);
router.post('/getPekerjaanById', perusahaanController.getPekerjaanById);
router.post('/getPekerjaanAndPerusahaanById', perusahaanController.getPekerjaanAndPerusahaanById);
router.post('/getPekerjaanAndLamaran',perusahaanController.getPekerjaanAndLamaran);

module.exports = router;
