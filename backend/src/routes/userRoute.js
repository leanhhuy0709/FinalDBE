const express = require('express');
const route = express.Router();

const userController = require("../controllers/userController");

route.get('/',userController.index);

module.exports = route;