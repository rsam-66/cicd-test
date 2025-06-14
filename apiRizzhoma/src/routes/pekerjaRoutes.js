const express = require('express');
const pekerjaController = require('../controllers/pekerjaController');
const router = express.Router();

router.post('/', pekerjaController.createPekerja);
router.post('/checkEmail', pekerjaController.ambilPekerjaByEmail);
router.post('/verifyPassword', pekerjaController.logIn);
router.post('/getDataPekerja', pekerjaController.ambilPekerjaById);
router.post('/addRingkasan', pekerjaController.addRingkasan);
router.post('/addInformasiPekerjaan', pekerjaController.addInformasiPekerjaan);
//belum ada di API daffa dan farid
router.post('/addInformasiPendidikan', pekerjaController.addInformasiPendidikan);
router.post('/addInformasiLisensi', pekerjaController.addInformasiLisensi);
router.post('/addSkills', pekerjaController.addSkills);
router.post('/getSkills', pekerjaController.getSkills);
router.post('/deleteSkills',pekerjaController.deleteSkills);
//bahasa
router.post('/addBahasa', pekerjaController.addBahasa);
router.post('/uploadResume', pekerjaController.uploadResume);
router.post('/updatePekerja', pekerjaController.updatePekerja);
router.post('/createLamaran', pekerjaController.createLamaran);
router.get('/getLamaran',pekerjaController.getAllLamaran);
router.post('/handleLamaran',pekerjaController.handleLamaranAction);
router.post('/getResume',pekerjaController.getResume);

module.exports = router;
