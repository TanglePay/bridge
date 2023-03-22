require("@nomicfoundation/hardhat-toolbox");
require("hardhat-gas-reporter");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "smrevm1070",
  networks: {
    hardhat: {
      blockGasLimit: 90000000
    },
    smrevm1070: {
      url: "https://json-rpc.evm.testnet.shimmer.network/",
      accounts: [process.env.RMS_EVM_PRIVATEKEY],
    },
    mumbai: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: [process.env.MUMBAI_PRIVATEKEY]
    }
  },
  gasReporter: {
    enabled: true,
    noColors: true
  },
  solidity: {
    compilers: [{
            version: "0.8.19",
            settings: {
                optimizer: {
                    enabled: true,
                    runs: 200,
                },
            },
        }
    ]
}
};
