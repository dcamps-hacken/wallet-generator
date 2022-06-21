const { ethers } = require("ethers")

module.exports = async ({ deployments, getNamedAccounts }) => {
    const { deploy, log } = deployments
    const { user1 } = await getNamedAccounts()

    walletGenerator = await ethers.getContract("WalletGenerator")

    const newWallet = await walletGenerator.connect(user1).getLatestWallet()
    console.log(newWallet)
}
