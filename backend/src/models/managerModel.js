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

const getProject = () => {
  console.log(connection);
  const query = "call ShowProject();";
  return new Promise((resolve, reject) => {
    connection.query(query, (err, result) => {
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

const delProject = (pid) => {
  var query = "call RemoveProject(?);";
  return new Promise((resolve, reject) => {
    connection.query(query, [pid], (err, result) => {
      if (err) reject(err);
      else resolve(result);
    });
  });
};

const addNewProject = (project) => {
  var query = "call insert_project(?, ?, ?, ?, ?);";
  return new Promise((resolve, reject) => {
    connection.query(query, project, (err, result) => {
      if (err) reject(err);
      else resolve(result);
    });
  });
};

const getEmployee = () => {
  var query = "call ShowEmployee();";
  return new Promise((resolve, reject) => {
    connection.query(query, (err, result) => {
      if (err) reject(err);
      else resolve(result);
    });
  });
};

const getProduct = () => {
  var query = "call ShowProduct();";
  return new Promise((resolve, reject) => {
    connection.query(query, (err, result) => {
      if (err) reject(err);
      else resolve(result);
    });
  });
};
module.exports = {
  getProject,
  addNewProject,
  delProject,
  getProjectGroup,
  getProjectLeader,
  getProjectModel,
  getProjectSupplier,
  getEmployee,
  getProduct,
};
