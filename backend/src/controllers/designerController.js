const {
  getProject,
  getGroup,
  getProduct,
  getModel,
  getProjectGroup,
  getProjectLeader,
  getProjectModel,
  getProjectSupplier
} = require("../models/designerModel");

module.exports.index = async (req, res) => {
  res.send("manager'home");
};

module.exports.getModel = async (req, res) => {
  getModel(req.query.id)
    .then((result) => {
      return res.json(result);
    })
    .catch((err) => res.json({ msg: err.message }));
};

module.exports.getProject = async (req, res) =>
{
  getProject(req.query.id)
  .then((result) => {
    return res.json(result);
  })
  .catch((err) => res.json({ msg: err.message }));
};

module.exports.getProduct = async (req, res) =>
{
  getProduct(req.query.id)
  .then((result) => {
    return res.json(result);
  })
  .catch((err) => res.json({ msg: err.message }));
};

module.exports.getGroup = async (req, res) =>
{
  getGroup(req.query.id)
  .then((result) => {
    return res.json(result);
  })
  .catch((err) => res.json({ msg: err.message }));
};

module.exports.getProjectInfo = async (req, res) => {
  const pid = req.query.pid;
  Promise.all([
    getProjectGroup(pid),
    getProjectLeader(pid),
    getProjectModel(pid),
    getProjectSupplier(pid),
  ])
    .then((result) => {
      return res.json(result);
    })
    .catch((err) => res.json({ msg: err.message }));
};
//----------------------------------------------------------------
module.exports.addModel = async (req, res) =>
{
  addModel()
  .then((result) => {
    return res.json(result);
  })
  .catch((err) => res.json({ msg: err.message }));
};