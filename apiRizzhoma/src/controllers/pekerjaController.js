const pekerjaModel = require("../models/pekerjaModel");
const PekerjaModel = require("../models/pekerjaModel");
const ResponseHandler = require("../utils/responseHandler");

class pekerjaController {
  static createPekerja(req, res) {
    const { username, email, password } = req.body;
    if (!username || !email || !password) {
      return ResponseHandler.error(res, 400, "Semua field harus diisi");
    }
    PekerjaModel.createPekerja(username, email, password, (error, result) => {
      if (error) {
        return ResponseHandler.error(res, 400, error.message);
      }
      PekerjaModel.ambilSemuaPekerja((error, pekerjas) => {
        if (error) {
          return ResponseHandler.error(res, 400, error.message);
        }
        ResponseHandler.sukses(res, 201, pekerjas);
      });
    });
  }
  
  static ambilSemuaPekerja(req, res) {
    console.log("Mengambil semua data pekerja...");

    PekerjaModel.ambilSemuaPekerja((error, pekerjas) => {
      if (error) {
        console.error(error);
        return ResponseHandler.error(res, 500, error.message);
      }
      ResponseHandler.sukses(res, 200, pekerjas);
    });
  }

  static ambilPekerjaByEmail(req, res) {
    console.log("Mengambil semua data pekerja...");
    const {email} = req.body;
    PekerjaModel.ambilPekerjaByEmail(email,(error, pekerjas) => {
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

        const user = await PekerjaModel.logIn(email, password);

        if (!user) {
            return res.status(200).send({ message: 'Invalid email or password', passwordCorrect: false});
        }

        return res.status(200).send({ message: 'Login successful', user, passwordCorrect: true });
    } catch (error) {
        console.error('Error during login:', error);
        return res.status(500).send({ message: 'Internal server error' , passwordCorrect: false});
    }
  }

  static async ambilPekerjaById(req, res) {
    const {idPekerja} = req.body;
    PekerjaModel.ambilPekerjaById(idPekerja,(error, pekerjas) => {
      if (error) {
        console.error(error);
        return ResponseHandler.error(res, 500, error.message);
      }
      ResponseHandler.sukses(res, 200, pekerjas);
    });
  }

  static async addRingkasan(req, res) {
    const {idPekerja,ringkasan} = req.body;
    PekerjaModel.addRingkasan(idPekerja, ringkasan,(error, pekerjas) => {
      if (error) {
        console.error(error);
        return ResponseHandler.error(res, 500, error.message);
      }
      ResponseHandler.sukses(res, 200, pekerjas);
    });
  }

  static async updatePekerja(req, res) {
    const { idPekerja, username, lokasi, nomorHP, email } = req.body;

    try {
        // First, check if the email already exists
        PekerjaModel.ambilPekerjaByEmail(email, (error, pekerjas) => {
            if (error) {
                console.error("Error fetching pekerja by email:", error);
                return ResponseHandler.error(res, 500, "Error checking email existence.");
            }

            // If no pekerja found with the email or it's the same pekerja
            if (!pekerjas || pekerjas.length === 0 || pekerjas[0].idPekerja === idPekerja) {
                // Proceed to update pekerja data
                PekerjaModel.updatePekerja(idPekerja, username, lokasi, nomorHP, email, (updateError, updatedPekerja) => {
                    if (updateError) {
                        console.error("Error updating pekerja:", updateError);
                        return ResponseHandler.error(res, 500, "Error updating pekerja data.");
                    }

                    return res.status(200).json({
                        dontExist: true,
                        success: true,
                        message: "Perusahaan data successfully updated.",
                        data: updatedPekerja,
                    });
                });
            } else {
                // If email already exists for another pekerja
                return res.status(200).json({
                    dontExist: false,
                    success: true,
                    message: "Email is already associated with another pekerja.",
                });
            }
        });
    } catch (exception) {
        console.error("Unexpected error:", exception);
        return ResponseHandler.error(res, 500, "An unexpected error occurred.");
    }
}



  static async addInformasiPekerjaan(req,res){
    const {idPekerja, posisiPekerjaan, namaPerusahaan, tahunMulaiPekerjaan, tahunBerakhirPekerjaan, statusJabatanPekerjaan, deskripsiPekerjaan} = req.body;
    PekerjaModel.addInformasiPekerjaan(idPekerja, posisiPekerjaan, namaPerusahaan, tahunMulaiPekerjaan, tahunBerakhirPekerjaan, statusJabatanPekerjaan, deskripsiPekerjaan,(error, pekerjas) => {
      if (error) {
        console.error(error);
        return ResponseHandler.error(res, 500, error.message);
      }
      ResponseHandler.sukses(res, 200, pekerjas);
    });
  }
  
  static async addInformasiPendidikan(req,res){
    const {idPekerja, kursusPendidikan, lembagaPendidikan, statusKualifikasiPendidikan, tahunSelesaiPendidikan, poinPentingPendidikan} = req.body;
    PekerjaModel.addInformasiPendidikan(idPekerja, kursusPendidikan, lembagaPendidikan, statusKualifikasiPendidikan, tahunSelesaiPendidikan, poinPentingPendidikan,(error, pekerjas) => {
      if (error) {
        console.error(error);
        return ResponseHandler.error(res, 500, error.message);
      }
      ResponseHandler.sukses(res, 200, pekerjas);
    });
  }

  static async addInformasiLisensi(req,res){
    const {idPekerja, namaLisensi, organisasiPenerbitLisensi, tanggalTerbitLisensi, tanggalKadaluwarsaLisensi, statusLisensi, deskripsiLisensi}=req.body;
    PekerjaModel.addInformasiLisensi(idPekerja, namaLisensi, organisasiPenerbitLisensi, tanggalTerbitLisensi, tanggalKadaluwarsaLisensi, statusLisensi, deskripsiLisensi,(error, pekerjas) => {
      if (error) {
        console.error(error);
        return ResponseHandler.error(res, 500, error.message);
      }
      ResponseHandler.sukses(res, 200, pekerjas);
    });
  }  
  static async addSkills(req, res) {
    const { idPekerja, skills } = req.body;

    if (!idPekerja || !Array.isArray(skills)) {
        return ResponseHandler.error(res, 400, "Invalid input");
    }

    try {
        PekerjaModel.addSkills(idPekerja, skills, (error, results) => {
            if (error) {
                console.error(error);
                return ResponseHandler.error(res, 500, "Failed to save skills");
            }
            return ResponseHandler.sukses(res, 200, "Skills saved successfully");
        });
    } catch (error) {
        console.error(error);
        return ResponseHandler.error(res, 500, "Unexpected error occurred");
    }
  }
  static async getSkills(req, res) {
    const { idPekerja } = req.body;

    if (!idPekerja) {
        return res.status(400).json({
            success: false,
            message: "idPekerja is required.",
        });
    }

    try {
        PekerjaModel.getSkills(idPekerja, (error, results) => {
            if (error) {
                console.error("Error fetching skills:", error);
                return res.status(500).json({
                    success: false,
                    message: "Failed to fetch skills.",
                });
            }

            return res.status(200).json({
                success: true,
                skills: results,
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

  static async deleteSkills(req,res){
    const { idPekerja } = req.body;

    if (!idPekerja) {
        return res.status(400).json({
            success: false,
            message: "idPekerja is required.",
        });
    }

    try {
        PekerjaModel.deleteSkills(idPekerja, (error, results) => {
            if (error) {
                console.error("Error fetching skills:", error);
                return res.status(500).json({
                    success: false,
                    message: "Failed to fetch skills.",
                });
            }

            return res.status(200).json({
                success: true,
                skills: results,
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

  static async addBahasa(req, res) {
    const { idPekerja, bahasa } = req.body;

    try {
        PekerjaModel.addBahasa(idPekerja, bahasa, (error, results) => {
            if (error) {
                console.error(error);
                return ResponseHandler.error(res, 500, "Failed to save bahasas");
            }
            return ResponseHandler.sukses(res, 200, "Bahasas saved successfully");
        });
    } catch (error) {
        console.error(error);
        return ResponseHandler.error(res, 500, "Unexpected error occurred");
    }
  }

  static async uploadResume(req, res) {
    const { idPekerja, resume, namaResume } = req.body;

    // Validate input
    if (!idPekerja || !resume ||!namaResume) {
        return res.status(400).json({
            success: false,
            message: "Missing required fields.",
        });
    }

    try {

        PekerjaModel.uploadResume(idPekerja, resume, namaResume, (error, result) => {
            if (error) {
                console.error("Database Error:", error);
                return res.status(500).json({
                    success: false,
                    message: "Database error occurred.",
                });
            }

            // Respond with success
            return res.status(200).json({
                success: true,
                message: "File uploaded successfully!",
                data: result,
            });
        });
    } catch (error) {
        console.error("Error in uploadResume:", error);
        return res.status(500).json({
            success: false,
            message: "An unexpected error occurred.",
        });
    }
  }

  static async createLamaran(req,res){
    const { idPekerja, idPekerjaan, jawaban} = req.body;
    try {
      PekerjaModel.createLamaran(idPekerja, idPekerjaan, jawaban, (error, results) => {
          if (error) {
              console.error(error);
              return ResponseHandler.error(res, 500, "Failed to save bahasas");
          }
          return ResponseHandler.sukses(res, 200, "Bahasas saved successfully");
      });
    } catch (error) {
        console.error(error);
        return ResponseHandler.error(res, 500, "Unexpected error occurred");
    }
  };
  static async getAllLamaran(req, res) {
    try {
        pekerjaModel.getAllLamaran((error, lamaran) => {
            if (error) {
                console.error("Error fetching lamaran:", error);
                return res.status(500).json({
                    success: false,
                    message: "Failed to fetch lamaran data.",
                });
            }

            return res.status(200).json({
                success: true,
                lamaran,
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

static async handleLamaranAction(req, res) {
    const { idLamaran, status } = req.body;

    try {
        pekerjaModel.handleLamaranAction(idLamaran, status, (error, results) => {
            if (error) {
                console.error("Error updating lamaran:", error);
                return res.status(500).json({
                    success: false,
                    message: "Failed to process the action.",
                });
            }

            return res.status(200).json({
                success: true,
                message: "Lamaran action processed successfully.",
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
static async getResume(req, res) {
  const { idPekerja } = req.body;

  try {
      pekerjaModel.getResume(idPekerja, (error, results) => {
          if (error) {
              console.error("Error updating lamaran:", error);
              return res.status(500).json({
                  success: false,
                  message: "Failed to process the action.",
              });
          }

          return res.status(200).json({
              success: true,
              data:results,
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

module.exports = pekerjaController;
