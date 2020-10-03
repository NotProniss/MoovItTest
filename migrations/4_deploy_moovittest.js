const MoovItTest = artifacts.require("MoovItTest.sol");
module.exports = function (deployer, network, accounts) {
  const _name = "MoovIt";
  const _symbol = "MOOV";
  const _decimals = 5;
  const _cap = 51010000000000;
  deployer.deploy(MoovItTest, _name, _symbol, _decimals, _cap);
};
