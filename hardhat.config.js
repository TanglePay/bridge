require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  defaultNetwork: "smrevm1071",
  networks: {
    smrevm1071: {
      url: "https://json-rpc.evm.testnet.shimmer.network/",
      accounts: [process.env.RMS_EVM_PRIVATEKEY],
    },
    mumbai: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: [process.env.MUMBAI_PRIVATEKEY]
    }
  }
};
