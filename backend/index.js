require("express-async-errors");
require("dotenv").config();
var express = require("express");
var app = express();
const helmet = require("helmet");
const cookieParser = require("cookie-parser");
const cors = require("cors");
app.use(
  cors({
    origin: "http://localhost:6000",
    credentials: true,
  })
);
app.use(helmet());
app.use(cookieParser(process.env.JWT_SECRET));
app.use(express.json());

const route = require("./src/routes");
route(app);

app.listen(6000, function () {
  console.log("Server is listening on port 6000!");
});
