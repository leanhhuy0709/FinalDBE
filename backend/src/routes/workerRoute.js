const express = require("express");
const workerController = require("../controllers/workerController");
const route = express.Router();

route.get("/", workerController.index);
route.get("/project", workerController.getProject);
route.get("/product", workerController.getProduct);
route.get("/group", workerController.getGroup);
route.get("/equipment", workerController.getEquipment);
route.get("/projectInfo", workerController.getProjectInfo);
route.post("/addComment", workerController.addComment);
module.exports = route;
