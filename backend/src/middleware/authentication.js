const {
  createJWT,
  isTokenValid,
  attachCookiesToResponse,
  createRefreshJWT,
} = require("../services/jwt");
const { UnauthenticatedError } = require("../errors");

function isAuthenticated(token, refreshToken) {
  try {
    isTokenValid(token);
    const { exp } = isTokenValid(refreshToken);
    if (Date.now() >= exp * 1000) {
      return false;
    }
  } catch (err) {
    return false;
  }
  return true;
}

const authUser = async (req, res, next) => {
  let token = req.cookies.token;
  let refreshToken = req.cookies.refreshToken;

  if (!token) throw new UnauthenticatedError("No token");
  try {
    const payLoad = await isTokenValid(refreshToken);
    if (!isAuthenticated(token, refreshToken)) {
    // create new token
    const token = createJWT({
      name: payLoad.name,
      role: payLoad.role,
    });
    // create new refrestoken
    const refreshToken = createRefreshJWT({
      name: payLoad.name,
      role: payLoad.role,
    });

      attachCookiesToResponse({ res, token, refreshToken });
    }
    // attach the user to the job route
    req.user = {
      name: payLoad.name,
      role: payLoad.role,
    };
  } catch (error) {
    throw new UnauthenticatedError("Authentication invalid 2");
  }
  next();
};

const authManger = async (req, res, next) => {
  if (req.user.role != "manager") {
    throw new UnauthenticatedError("You are not manager");
  }
  next();
};

const authWorker = async (req, res, next) => {
  if (req.user.role != "worker") {
    throw new UnauthenticatedError("You are not worker");
  }
  next();
};

const authAnalyst = async (req, res, next) => {
  if (req.user.role != "analyst") {
    throw new UnauthenticatedError("You are not analyst");
  }
  next();
};

const authDesigner = async (req, res, next) => {
  if (req.user.role != "designer") {
    throw new UnauthenticatedError("You are not designer");
  }
  next();
};

module.exports = { authUser, authManger, authWorker, authAnalyst, authDesigner };
