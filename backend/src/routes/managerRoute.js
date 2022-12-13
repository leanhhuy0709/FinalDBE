const express = require("express");
const route = express.Router();
const managerController = require("../controllers/managerController");

route.get("/project", managerController.showProject);//
route.delete("/project", managerController.deleteProject);
route.get("/projectInfo", managerController.showProjectInfo);
route.post("/addproject", managerController.addProject);
route.get("/employee", managerController.showEmployee);//
route.get("/product", managerController.showProduct);//

route.get("/", managerController.index);

module.exports = route;
