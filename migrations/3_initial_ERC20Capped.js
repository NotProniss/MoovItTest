const ERC20Capped = artifacts.require("ERC20Capped");

module.exports = function (deployer, network, accounts) {
  deployer.deploy(ERC20Capped, 51010000000000);
};
