# WALLET GENERATOR

This wallet generator allows any user to deploy Simple or Multisig wallets for EVM-compatible blockchains.

### HOW IT WORKS

In order to create your wallet you will interact with the smart contract called "WalletGenerator". This contract is deployed on different blockchains so that you can chose where to create your wallet. 

Note that you will also require Metamask or another wallet in order to interact with the contract. If you don't have any, you can create one following [these instructions --> ADD LINK]. 

Head to the corresponding block explorer to interact with the "WalletGenerator":

- Ethereum's Rinkeby testnet
- Polygon's Mumbai testnet
- Gnosis Chain
- ZkSync

### TYPES OF WALLETS

Once you find the "WalletGenerator" contract, you will see several functions:


##### Simple Wallet

Use the createWallet() function if you want to create a wallet linked to your metamask address. 

Since it has no arguments you don't need to input anything. A message will pop on Metamask asking you to approve a transaction that will create your wallet.

This wallet allows you to receive or transfer funds, get your balance or withdraw all your money.


##### Destroyable Wallet

createDestroyableWallet() will generate a Simple Wallet that can also be destroyed at any point. 

In order to add an extra layer of security, the destroy functionality is a two-step process. Therefore, you will first need to call the function preDestroy(), that will change the status of the wallet to "PREDESTROY", and later use the function destroyWallet(). 

Once the wallet is destroyed, all its funds will be sent to the address you provided.


##### Multi-Signature Wallet

Use createMultisigWallet() if you want a shared wallet that requires multi-signature to send transactions.

In order to call this function, some arguments must be provided:

- _owners is a list of addresses, separated by comas, that correspond to the owners of the wallet (i.e. people who can sign, approve or send transactions).

- _requiredConfirmations is the number of times you want a transaction to be approved before it can be executed. 


### HOW TO GET THE ADDRESS OF YOUR WALLET

Three functions have been added in the "WalletGenerator" contract with the purpose of getting the address of any wallet you created.

Use getLatestWallet() if you just want to get the address of the wallet you just generated.

With getWalletFromId() you can obtain the address of a given wallet. You need to the input the parameter '_Id' to get it, which corresponds to the order in which you created your wallets (use '0' to get the first wallet you created, '1' for the second, and so on).

If you don't remember the ID of your wallet or just want to get every wallet you ever created, use the function getAllWallets(). It will provide a time-ordered list of all your wallet addresses.







---------------------

This project demonstrates an advanced Hardhat use case, integrating other tools commonly used alongside Hardhat in the ecosystem.

The project comes with a sample contract, a test for that contract, a sample script that deploys that contract, and an example of a task implementation, which simply lists the available accounts. It also comes with a variety of other tools, preconfigured to work with the project code.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
npx hardhat help
REPORT_GAS=true npx hardhat test
npx hardhat coverage
npx hardhat run scripts/deploy.js
node scripts/deploy.js
npx eslint '**/*.js'
npx eslint '**/*.js' --fix
npx prettier '**/*.{json,sol,md}' --check
npx prettier '**/*.{json,sol,md}' --write
npx solhint 'contracts/**/*.sol'
npx solhint 'contracts/**/*.sol' --fix
```

# Etherscan verification

To try out Etherscan verification, you first need to deploy a contract to an Ethereum network that's supported by Etherscan, such as Ropsten.

In this project, copy the .env.example file to a file named .env, and then edit it to fill in the details. Enter your Etherscan API key, your Ropsten node URL (eg from Alchemy), and the private key of the account which will send the deployment transaction. With a valid .env file in place, first deploy your contract:

```shell
hardhat run --network ropsten scripts/deploy.js
```

Then, copy the deployment address and paste it in to replace `DEPLOYED_CONTRACT_ADDRESS` in this command:

```shell
npx hardhat verify --network ropsten DEPLOYED_CONTRACT_ADDRESS "Hello, Hardhat!"
```
