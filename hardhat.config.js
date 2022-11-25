require("@nomicfoundation/hardhat-toolbox")
require('dotenv').config({ path: __dirname + '/.env' })

const { API_URL, PRIVATE_KEY, ETHERSCAN_API_KEY } = process.env

module.exports = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: API_URL,
      accounts: [PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: {
      goerli: ETHERSCAN_API_KEY
    },
    customChains: [
      {
        network: "goerli",
        chainId: 5,
        urls: {
          apiURL: "https://api-goerli.etherscan.io/api",
          browserURL: "https://goerli.etherscan.io"
        }
      }
    ]
  },
  settings: {
    optimizer: {
      enabled: true,
      runs: 200,
    },
  }
};

task("deploy-testnets", "Deploys contract on a provided network")
    .addParam("privateKey", "Please provide the private key")
    .setAction(async (taskArgs, hre, runSuper) => {
        const deployContract = require("./scripts/deploy");
        await deployContract(taskArgs);
    });

task("verify-contract", "Verify a contract")
    .addParam("contractAddress", "Please provide the contract address")
    .setAction(async (taskArgs, hre, runSuper) => {
        const verify = require("./scripts/verify");
        await verify(taskArgs);
    });