const { verify } = require("../utils/verify.js")

module.exports = async ({ deployments, getNamedAccounts }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()

    const args = []
    const walletGenerator = await deploy("WalletGenerator", {
        from: deployer,
        args: args,
        log: true,
        //waitConfirmations: 5,
    })

    //await verify(walletGenerator.address)
}
module.exports.tags = ["all"]
