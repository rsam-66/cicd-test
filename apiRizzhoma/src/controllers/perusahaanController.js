const PerusahaanModel = require("../models/perusahaanModel");
const ResponseHandler = require("../utils/responseHandler");

class perusahaanController{
    static createPerusahaan(req, res) {
    const { username, email, password, nomorHP, namaBisnis } = req.body;
    if (!username || !email || !password || !nomorHP || !namaBisnis) {
        return ResponseHandler.error(res, 400, "Semua field harus diisi");
    }
    PerusahaanModel.createPerusahaan(username, email, password, nomorHP, namaBisnis, (error, result) => {
        if (error) {
        return ResponseHandler.error(res, 400, error.message);
        }
        PerusahaanModel.ambilSemuaPerusahaan((error, perusahaans) => {
        if (error) {
            return ResponseHandler.error(res, 400, error.message);
        }
        ResponseHandler.sukses(res, 201, perusahaans);
        });
    });
    }
    static ambilPerusahaanByEmail(req, res) {
        console.log("Mengambil semua data pekerja...");
        const {email} = req.body;
        PerusahaanModel.ambilPerusahaanByEmail(email,(error, pekerjas) => {
          if (error) {
            console.error(error);
            return ResponseHandler.error(res, 500, error.message);
          }
          ResponseHandler.sukses(res, 200, pekerjas);
        });
      }
      static async logIn(req, res) {
        try {
            const { email, password } = req.body;
    
            const user = await PerusahaanModel.logIn(email, password);
    
            if (!user) {
                return res.status(200).send({ message: 'Invalid email or password', passwordCorrect: false});
            }
    
            return res.status(200).send({ message: 'Login successful', user, passwordCorrect: true });
        } catch (error) {
            console.error('Error during login:', error);
            return res.status(500).send({ message: 'Internal server error' , passwordCorrect: false});
        }
      }

      static async ambilPerusahaanById(req, res) {
        const { idPerusahaan } = req.body;
    
        PerusahaanModel.ambilPerusahaanById(idPerusahaan, (error, perusahaan) => {
            if (error) {
                console.error(error);
                return ResponseHandler.error(res, 500, error.message);
            }
    
            ResponseHandler.sukses(res, 200, perusahaan[0]);
        });
    }
    
    

      static async uploadPekerjaan(req, res) {
        const {idPerusahaan,judulPekerjaan,lokasiPekerjaan,kategoriJabatan,kategoriGaji,jenisGaji,kisaranGaji,bannerPerusahaan,deskripsiPerusahaan,linkReferensi, pertanyaan} = req.body;
        PerusahaanModel.uploadPekerjaan(idPerusahaan,judulPekerjaan,lokasiPekerjaan,kategoriJabatan,kategoriGaji,jenisGaji,kisaranGaji,bannerPerusahaan,deskripsiPerusahaan,linkReferensi, pertanyaan,(error, pekerjas) => {
          if (error) {
            console.error(error);
            return ResponseHandler.error(res, 500, error.message);
          }
          ResponseHandler.sukses(res, 200, pekerjas);
        });
      }
      
      static async getPekerjaan(req, res) {
        const { idPerusahaan } = req.body;
        if (!idPerusahaan) {
            return res.status(400).json({
                success: false,
                message: "idPekerja is required.",
            });
        }
        try {
            PerusahaanModel.getPekerjaan(idPerusahaan, (error, results) => {
                if (error) {
                    console.error("Error fetching skills:", error);
                    return res.status(500).json({
                        success: false,
                        message: "Failed to fetch skills.",
                    });
                }

                return res.status(200).json({
                    success: true,
                    pekerjaans: results,
                });
            });
        } catch (error) {
            console.error("Unexpected error:", error);
            return res.status(500).json({
                success: false,
                message: "An unexpected error occurred.",
            });
        }
      }

      static async getPekerjaanById(req, res) {
        const { idPekerjaan } = req.body;
        if (!idPekerjaan) {
            return res.status(400).json({
                success: false,
                message: "idPekerja is required.",
            });
        }
        try {
            PerusahaanModel.getPekerjaanById(idPekerjaan, (error, results) => {
                if (error) {
                    console.error("Error fetching skills:", error);
                    return res.status(500).json({
                        success: false,
                        message: "Failed to fetch skills.",
                    });
                }

                return res.status(200).json({
                    success: true,
                    pekerjaans: results,
                });
            });
        } catch (error) {
            console.error("Unexpected error:", error);
            return res.status(500).json({
                success: false,
                message: "An unexpected error occurred.",
            });
        }
      }

      static async updatePerusahaan(req, res) {
        const { idPerusahaan, nomorHP,kontakUtama, alamatPerusahaan, emailPenagihan, logoPerusahaan } = req.body;
        if (!idPerusahaan) {
            return res.status(400).json({
                success: false,
                message: "idPerusahaan is required.",
            });
        }
        try {
            PerusahaanModel.updatePerusahaan(idPerusahaan, nomorHP,kontakUtama,alamatPerusahaan,emailPenagihan,logoPerusahaan,(error, results) => {
                if (error) {
                    console.error("Error fetching skills:", error);
                    return res.status(500).json({
                        success: false,
                        message: "Failed to fetch skills.",
                    });
                }

                return res.status(200).json({
                    success: true,
                    pekerjaans: results,
                });
            });
        } catch (error) {
            console.error("Unexpected error:", error);
            return res.status(500).json({
                success: false,
                message: "An unexpected error occurred.",
            });
        }
      }
      static async getPerusahaanAndPekerjaan(req, res) {
        try {
            PerusahaanModel.getPerusahaanAndPekerjaan((error, results) => {
                if (error) {
                    console.error("Error fetching skills:", error);
                    return res.status(500).json({
                        success: false,
                        message: "Failed to fetch skills.",
                    });
                }

                return res.status(200).json({
                    success: true,
                    pekerjaans: results,
                });
            });
        } catch (error) {
            console.error("Unexpected error:", error);
            return res.status(500).json({
                success: false,
                message: "An unexpected error occurred.",
            });
        }
      }
      static async getPekerjaanAndPerusahaanById(req, res) {
        const { idPekerjaan } = req.body;
        if (!idPekerjaan) {
            return res.status(400).json({
                success: false,
                message: "idPekerja is required.",
            });
        }
        try {
            PerusahaanModel.getPekerjaanAndPerusahaanById(idPekerjaan, (error, results) => {
                if (error) {
                    console.error("Error fetching skills:", error);
                    return res.status(500).json({
                        success: false,
                        message: "Failed to fetch skills.",
                    });
                }

                return res.status(200).json({
                    success: true,
                    pekerjaans: results,
                });
            });
        } catch (error) {
            console.error("Unexpected error:", error);
            return res.status(500).json({
                success: false,
                message: "An unexpected error occurred.",
            });
        }
      }


      //pemisah biar ga bingung


      static async getPekerjaanAndLamaran(req, res) {
        const { idPerusahaan, idPekerjaan } = req.body;
        if (!idPerusahaan) {
            return res.status(400).json({
                success: false,
                message: "idPekerja is required.",
            });
        }
        try {
            PerusahaanModel.getPekerjaanAndLamaran(idPerusahaan, idPekerjaan, (error, results) => {
                if (error) {
                    console.error("Error fetching skills:", error);
                    return res.status(500).json({
                        success: false,
                        message: "Failed to fetch skills.",
                    });
                }

                return res.status(200).json({
                    success: true,
                    pekerjaans: results,
                });
            });
        } catch (error) {
            console.error("Unexpected error:", error);
            return res.status(500).json({
                success: false,
                message: "An unexpected error occurred.",
            });
        }
      }
      
}
module.exports = perusahaanController;