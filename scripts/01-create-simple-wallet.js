const { deployments, ethers, getNamedAccounts } = require("hardhat")

async function main() {
    const { deployer, user1, user2 } = await getNamedAccounts()

    await deployments.fixture(["all"])
    walletGenerator = await ethers.getContract("WalletGenerator")

    //wallet = walletGenerator.connect(user1)
    await walletGenerator.createSimpleWallet()
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
