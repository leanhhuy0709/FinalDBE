const mysql = require("mysql2/promise");

// var connection = mysql.createConnection({
//     host: 'localhost',
//     user: 'root',
//     port: 3306,
//     password: '123456789',
//     database: 'manufacturing',
// });

// connection.connect((errors, connection) => {
//     if (errors) {
//         console.log('connection database errors... ' + errors.stack);
//         return;
//     }
//     else {
//         console.log('connection database sucessful...');
//     }
// })

async function testConnection(uname, pwd) {
  try {
    await mysql.createConnection({
      host: "localhost",
      database: "manufacturing",
      port: 3306,
      user: uname,
      password: pwd,
    });
    return true;
  } catch (e) {
    return false;
  }
}

async function makeConnection(uname, pwd) {
  try {
    const dbConnection = await mysql.createConnection({
      host: "localhost",
      database: "manufacturing",
      port: 3306,
      user: uname,
      password: pwd,
    });
    console.log("connection database sucessful...");
    return dbConnection;
  } catch (e) {
    console.log("error: ", e);
    return null;
  }
}

module.exports = {
  testConnection,
  makeConnection,
};
