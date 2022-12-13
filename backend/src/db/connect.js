const mysql = require("mysql");
require("dotenv").config();

const connectSuccess = (user) => {
  return mysql.createConnection({
    host: "localhost",
    user: user.DB_USERNAME,
    password: user.DB_PASSWORD,
    database: user.DB_NAME,
    multipleStatements: true,
  });
};

module.exports = { connectSuccess };
