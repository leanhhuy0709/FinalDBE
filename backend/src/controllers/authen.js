const { StatusCodes } = require("http-status-codes");
const { BadRequestError, UnauthenticatedError } = require("../errors");
const { getUser } = require("../../account/account");
const {
  createJWT,
  attachCookiesToResponse,
  createRefreshJWT,
} = require("../services/jwt");
const { connectSuccess } = require("../db/connect");

const login = async (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) {
    throw new BadRequestError("Please provide email and password");
  }

  const user = getUser(username, password);
  // comparing password
  if (!user) {
    throw new UnauthenticatedError("Invalid credentials");
  }

  // create new token
  const token = createJWT({
    name: user.username,
    role: user.role,
  });

  // create new refrestoken
  const refreshToken = createRefreshJWT({
    name: user.username,
    role: user.role,
  });

  attachCookiesToResponse({ res, token, refreshToken });

  try {
    await connectSuccess(user);
    console.log("Database connected! Username: ", user.username);
  } catch (error) {
    console.log(error.message);
  }
  res.status(StatusCodes.OK).json({ msg: "Login sucess", user });
};

const logout = (req, res) => {
  res.cookie("token", "token", {
    httpOnly: true,
    expires: new Date(Date.now()),
  });
  res.cookie("refreshToken", "refreshToken", {
    httpOnly: true,
    expires: new Date(Date.now()),
  });
  res.status(StatusCodes.OK).json({ msg: "Logout sucess" });
};

module.exports = { login, logout };
