// We usually run this kind of script with
// 1) imports
// 2) main function
// 3) call main function

// In this case we will define a default function for the "hardhat-deploy" too look for
//function deployFunc() {
//    console.log("Hi")
//    // ...
//}
//module.exports.default = deployFunc

//however, the standard way to write the function is as an anonymous async function:
//module.exports = async(hre) => {
//    const { getNamedAccounts, deployments } = hre // pull the variables out of hre
//    // this would be equivalent to:
//    //hre.getNamedAccounts
//    //hre.deployments
//}

const { networkConfig, developmentChains } = require("../helper-hardhat-config")
const { network } = require("hardhat")
const { verify } = require("../utils/verify")

// thanks to JS syntatic sugar, we can squeeze that in one line on the function declaration:
module.exports = async ({ getNamedAccounts, deployments }) => {
    // we use the deployments object to get 2 functions: deploy and log
    const { deploy, log } = deployments
    //ethers allow us to get accounts from the accounts section of each network
    const { deployer } = await getNamedAccounts()
    const chainId = network.config.chainId

    //we will use an aave approach to set the address depending on the chainId --> helper hardhat config
    let ethUsdPriceFeedAddress
    if (developmentChains.includes(network.name)) {
        //case in which we work on local network
        const ethUsdAggregator = await deployments.get("MockV3Aggregator")
        ethUsdPriceFeedAddress = ethUsdAggregator.address
    } else {
        //case in which we work with testnet or mainnet
        ethUsdPriceFeedAddress = networkConfig[chainId]["ethUsdPriceFeed"]
    }
    //this will not work for a local network since it cannot access price feeds, then
    //we will need to mock the price feed --> we will use a deploy mock script

    //when using a localhost or hardhat network we will use a mock
    const args = [ethUsdPriceFeedAddress]
    const fundMe = await deploy("FundMe", {
        //we add a list of overrides for the contract
        from: deployer,
        args: args, //constructor args --> priceFeed address
        log: true, //custom logs to not need console.log and stuff --> tx ID and contract address
        waitConfirmations: network.config.blockConfirmations || 1, //if no hardhat confirmations especified, wait 1 block
    })

    if (
        !developmentChains.includes(network.name) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        await verify(fundMe.address, args)
    }

    log("---------------------")
}

module.exports.tags = ["all", "fundme"]
