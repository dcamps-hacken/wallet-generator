module.exports = async ({ deployments, getNamedAccounts }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()

    const args = []
    await deploy("WalletGenerator", {
        from: deployer,
        args: args,
        log: true,
    })
}
