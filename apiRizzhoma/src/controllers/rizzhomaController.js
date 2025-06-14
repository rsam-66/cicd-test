const rizzhomaModel = require("../models/rizzhomaModel");
const ResponseHandler = require("../utils/responseHandler");

class rizzhomaController{
    static createUser(req, res) {
      const { username, email, password } = req.body;
      if (!username || !email || !password) {
          return ResponseHandler.error(res, 400, "Semua field harus diisi");
      }
      rizzhomaModel.createUser(username, email, password, (error, result) => {
          if (error) {
          return ResponseHandler.error(res, 400, error.message);
          }
          rizzhomaModel.ambilSemuaUser((error, users) => {
          if (error) {
              return ResponseHandler.error(res, 400, error.message);
          }
          ResponseHandler.sukses(res, 201, users);
          });
      });
    }
      
    static ambilSemuaUser(req, res) {
      console.log("Mengambil semua data pekerja...");

      rizzhomaModel.ambilSemuaUser((error, users) => {
          if (error) {
          console.error(error);
          return ResponseHandler.error(res, 500, error.message);
          }
          ResponseHandler.sukses(res, 200, users);
      });
    }
    
    static ambilUserByEmail(req, res) {
      console.log("Mengambil semua data user...");
      const {email} = req.body;
      rizzhomaModel.ambilUserByEmail(email,(error, users) => {
        if (error) {
          console.error(error);
          return ResponseHandler.error(res, 500, error.message);
        }
        ResponseHandler.sukses(res, 200, users);
      });
    }
    
    static async logIn(req, res) {
      try {
          const { email, password } = req.body;
  
          const user = await rizzhomaModel.logIn(email, password);
  
          if (!user) {
              return res.status(200).send({ message: 'Invalid email or password', passwordCorrect: false});
          }
  
          return res.status(200).send({ message: 'Login successful', user, passwordCorrect: true });
      } catch (error) {
          console.error('Error during login:', error);
          return res.status(500).send({ message: 'Internal server error' , passwordCorrect: false});
      }
    }
    
      static async ambilUserById(req, res) {
        const {userID} = req.body;
        rizzhomaModel.ambilUserById(userID,(error, users) => {
          if (error) {
            console.error(error);
            return ResponseHandler.error(res, 500, error.message);
          }
          ResponseHandler.sukses(res, 200, users);
        });
      }
    
      static async transaction(req,res){
        const { userID, totalAmount} = req.body;
        try {
          rizzhomaModel.transaction(userID, totalAmount, (error, results) => {
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

      static async ambilTransaction(req, res){
        const {userID} = req.body;
        rizzhomaModel.ambilTransaction(userID,(error, users) => {
          if (error) {
            console.error(error);
            return ResponseHandler.error(res, 500, error.message);
          }
          ResponseHandler.sukses(res, 200, users);
        });
      }

      static async ambilDonasi(req, res){
        try {
          rizzhomaModel.ambilDonasi((error, results) => {
              if (error) {
                  console.error("Error fetching skills:", error);
                  return res.status(500).json({
                      success: false,
                      message: "Failed to fetch skills.",
                  });
              }

              return res.status(200).json({
                  success: true,
                  donasis: results,
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

      static async ambilDonasiById(req, res) {
        const {donationID} = req.body;
        rizzhomaModel.ambilDonasiById(donationID,(error, users) => {
          if (error) {
            console.error(error);
            return ResponseHandler.error(res, 500, error.message);
          }
          ResponseHandler.sukses(res, 200, users);
        });
      }

      static async createTransaction(req,res){
        const { userID, donationID, totalAmount, methodName } = req.body;
        if (!userID || !donationID || !totalAmount || !methodName) {
            return ResponseHandler.error(res, 400, "Semua field harus diisi");
        }
        rizzhomaModel.createTransaction(userID, donationID, totalAmount, methodName, (error, result) => {
            if (error) {
            return ResponseHandler.error(res, 400, error.message);
            }
            rizzhomaModel.ambilSemuaUser((error, users) => {
            if (error) {
                return ResponseHandler.error(res, 400, error.message);
            }
            ResponseHandler.sukses(res, 201, users);
            });
        });
      }

      static async updateAmount(req,res){
        const {donationID, amount} = req.body;
        if (!donationID || !amount) {
          return ResponseHandler.error(res, 400, "Semua field harus diisi");
        }
        rizzhomaModel.updateAmount(donationID, amount, (error, result) =>
          {
            if (error) {
              return ResponseHandler.error(res, 400, error.message);
              }
            ResponseHandler.sukses(res, 200, result);
          }
        );
      }

      //Temporary code
      static ambilSemuaPohon(req, res) {
        console.log("Mengambil semua data pohon...");

        rizzhomaModel.ambilSemuaPohon((error, pohonList) => {
            if (error) {
                console.error(error);
                return ResponseHandler.error(res, 500, error.message);
            }
            ResponseHandler.sukses(res, 200, pohonList);
        });
    }
 
}

module.exports = rizzhomaController;