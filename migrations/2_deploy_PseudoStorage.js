const PseudoStorage = artifacts.require('PseudoStorage');

module.exports = function (deployer) {
  deployer.deploy(PseudoStorage);
};
