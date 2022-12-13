const express = require("express");
const route = express.Router();

const designerController = require("../controllers/designerController");

route.get("/", designerController.index);
route.get("/project", designerController.getProject);
route.get("/product", designerController.getProduct);
route.get("/group", designerController.getGroup);
route.get("/model", designerController.getModel);
route.get("/projectInfo", designerController.getProjectInfo);
route.post("/addModel", designerController.addModel);
module.exports = route;
