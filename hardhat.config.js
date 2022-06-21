require("dotenv").config()
require("@nomiclabs/hardhat-etherscan")
require("@nomiclabs/hardhat-waffle")
require("hardhat-gas-reporter")
require("solidity-coverage")
require("hardhat-deploy")

RINKEBY_RPC_URL = process.env.RINKEBY_RPC_URL
PRIVATE_KEY = process.env.PRIVATE_KEY
ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY

module.exports = {
    solidity: {
        compilers: [
            { version: "0.8.0" },
            { version: "0.7.0" },
            { version: "0.8.7" },
        ],
    },
    defaultNetwork: "hardhat",
    networks: {
        rinkeby: {
            url: RINKEBY_RPC_URL,
            accounts: [PRIVATE_KEY],
            chainId: 4,
            blockConfirmations: 4,
        },
        localhost: {
            url: "http://127.0.0.1:8545/",
            chainId: 31337,
        },
    },
    /* gasReporter: {
        enabled: false,
        outputFile: "gas-report.txt",
        noColors: true,
        currency: "USD",
        coinmarketcap: COINMARKETCAP_API_KEY,
        token: "MATIC",
    }, */
    etherscan: {
        apiKey: ETHERSCAN_API_KEY,
    },
    namedAccounts: {
        deployer: {
            default: 0, //takes account #0
        },
        user1: {
            //we can create a user
            default: 1, //takes account #1
        },
        user2: {
            //we can create a user
            default: 2, //takes account #2
        },
    },
}
