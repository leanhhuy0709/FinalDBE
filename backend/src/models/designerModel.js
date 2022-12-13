const mysql = require("mysql");
// const user = {
//   DB_USERNAME: "root",
//   DB_NAME : "manufacturing",
//   DB_PASSWORD : "1234",
// }
// const connection = mysql.createConnection({
//   host: "localhost",
//   user: user.DB_USERNAME,
//   password: user.DB_PASSWORD,
//   database: user.DB_NAME,
//   multipleStatements: true
// })
// const start = async ()=>{
//   try {
//   await connection.connect();
//   console.log("Database connected! Username: ", user.username);
//   } catch (error) {
//   console.log(error.message);
//   }
// }
// start();
const { connectSuccess } = require("../db/connect");
const user = {
  DB_USERNAME: "root",
  DB_PASSWORD: "kimngan1704",
  DB_NAME: "manufacturing",
};
const connection = connectSuccess(user);

const getModel = (id) => {
  var query = "call get_model_of_designer(?);";
  return new Promise((resolve, reject) => {
    connection.query(query, [id], (err, result) => {
      if (err) reject(err);
      else resolve(result);
    });
  });
};

const getProject = (id) => {
  var query = "call get_project_of_employee(?);";
  return new Promise((resolve, reject) => {
    connection.query(query, [id], (err, result) => {
      if (err) reject(err);
      else resolve(result);
    });
  });
};

const getProjectGroup = (pid) => {
  let query = "call get_group_of_project(?);";
  return new Promise((resolve, reject) => {
    connection.query(query, [pid], (err, result) => {
      if (err) reject(err);
      else resolve(result);
    });
  });
};

const getProjectLeader = (pid) => {
  let query = "call get_leader_of_project(?);";
  return new Promise((resolve, reject) => {
    connection.query(query, [pid], (err, result) => {
      if (err) reject(err);
      else resolve(result);
    });
  });
};

const getProjectModel = (pid) => {
  let query = "call get_model_of_project(?);";
  return new Promise((resolve, reject) => {
    connection.query(query, [pid], (err, result) => {
      if (err) reject(err);
      else resolve(result);
    });
  });
};

const getProjectSupplier = (pid) => {
  let query = "call get_supplier_of_project(?);";
  return new Promise((resolve, reject) => {
    connection.query(query, [pid], (err, result) => {
      if (err) reject(err);
      else resolve(result);
    });
  });
};

const getGroup = (id) => {
  var query = "call get_group_of_employee(?);";
  return new Promise((resolve, reject) => {
    connection.query(query, [id], (err, result) => {
      if (err) reject(err);
      else resolve(result);
    });
  });
};

const getProduct = (id) => {
  var query = "call get_product_of_designer(?);";
  return new Promise((resolve, reject) => {
    connection.query(query, [id], (err, result) => {
      if (err) reject(err);
      else resolve(result);
    });
  });
};

const addModel = () => {
  var query = "call get_product_of_designer(?);";
  return new Promise((resolve, reject) => {
    connection.query(query, [id], (err, result) => {
      if (err) reject(err);
      else resolve(result);
    });
  });
};

module.exports = {
  getModel,
  getProject,
  getProjectGroup,
  getProjectLeader,
  getProjectModel,
  getProjectSupplier,
  getGroup,
  getProduct,
  addModel,
};
