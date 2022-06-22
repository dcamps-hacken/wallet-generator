const { deployments, ethers, getNamedAccounts } = require("hardhat")

async function main() {
    const { deployer, user1, user2 } = await getNamedAccounts()

    await deployments.fixture(["all"])
    walletGenerator = await ethers.getContract("WalletGenerator")

    newWallet = await walletGenerator.getLatestWallet()
    console.log(newWallet.address)
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
