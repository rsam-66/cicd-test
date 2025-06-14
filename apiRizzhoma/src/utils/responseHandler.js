class ResponseHandler {
  static sukses(res, statusCode, data) {
    return res.status(statusCode).json({
      status: "success",
      data: data,
    });
  }

  static error(res, statusCode, message) {
    return res.status(statusCode).json({
      status: "error",
      message: message,
    });
  }
}

module.exports = ResponseHandler;
module.exports = ResponseHandler;
