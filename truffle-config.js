var HDWalletProvider = require("truffle-hdwallet-provider");
const infuraKey = "878fdfd83340439e8f2fe6f4e3aeb144";

const fs = require("fs");
var mnemonic = fs.readFileSync(".secret").toString().trim();


module.exports = {
  networks: {
   //development: {
  //   host: "localhost",
  //   port: 7545,
  //   network_id: "*", // Match any network id
  //   gas: 5000000
//   },
   rinkeby: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://rinkeby.infura.io/v3/878fdfd83340439e8f2fe6f4e3aeb144");
      },
      network_id: 4
    },
  compilers: {
    solc: {
      version: "^0.5.0",
      settings: {
        optimizer: {
          enabled: true, // Default: false
          runs: 200      // Default: 200
        },
      }
    }
  }
}
};
