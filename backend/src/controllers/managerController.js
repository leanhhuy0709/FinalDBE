const {
  getProject,
  addNewProject,
  delProject,
  getProjectGroup,
  getProjectLeader,
  getProjectModel,
  getProjectSupplier,
  getEmployee,
  getProduct,
} = require("../models/managerModel");

module.exports.index = async (req, res) => {
  res.send("manager'home");
};

module.exports.showProject = async (req, res) => {
  getProject()
    .then((result) => {
      return res.json(result);
    })
    .catch((err) => res.json({ msg: err.message }));
};

module.exports.deleteProject = async (req, res) => {
  const pid = req.query.pid;
  delProject(pid)
    .then((result) => {
      return res.json(result);
    })
    .catch((err) => res.json({ msg: err.message }));
};

module.exports.showProjectInfo = async (req, res) => {
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

module.exports.addProject = async (req, res) => {
  const project = [
    req.body.id,
    req.body.pname,
    req.body.description,
    req.body.cost_eff,
    req.body.cost,
  ];
  addNewProject(project)
    .then((result) => {
      return res.json(result);
    })
    .catch((err) => res.json({ msg: err.message }));
};

module.exports.showEmployee = async (req, res) => {
  getEmployee()
    .then((result) => {
      return res.json(result);
    })
    .catch((err) => res.json({ msg: err.message }));
};

module.exports.showProduct = async (req, res) => {
  getProduct()
    .then((result) => {
      return res.json(result);
    })
    .catch((err) => res.json({ msg: err.message }));
};
