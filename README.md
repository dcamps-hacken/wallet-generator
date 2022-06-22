# WALLET GENERATOR

⏳ This project is under construction ⏳

This wallet generator allows any user to deploy Simple or Multisig wallets for EVM-compatible blockchains.

### QUICKSTART 🚀

´´´
git clone https://github.com/fields93/wallet-generator.git
´´´

### TYPES OF WALLETS

Once you find the "WalletGenerator" contract, you will see several functions:

#### Simple Wallet

Use the createWallet() function if you want to create a wallet linked to your metamask address.

Since it has no arguments you don't need to input anything. A message will pop on Metamask asking you to approve a transaction that will create your wallet.

This wallet allows you to receive or transfer funds, get your balance or withdraw all your money.

<br>

#### Destroyable Wallet

createDestroyableWallet() will generate a Simple Wallet that can also be destroyed at any point.

In order to add an extra layer of security, the destroy functionality is a two-step process. Therefore, you will first need to call the function preDestroy(), that will change the status of the wallet to "PREDESTROY", and later use the function destroyWallet().

Once the wallet is destroyed, all its funds will be sent to the address you provided.

<br>

#### Multi-Signature Wallet

Use createMultisigWallet() if you want a shared wallet that requires multi-signature to send transactions.

In order to call this function, some arguments must be provided:

-   \_owners is a list of addresses, separated by comas, that correspond to the owners of the wallet (i.e. people who can sign, approve or send transactions).

-   \_requiredConfirmations is the number of times you want a transaction to be approved before it can be executed.

<br>

### HOW TO GET THE ADDRESS OF YOUR WALLET

Three functions have been added in the "WalletGenerator" contract with the purpose of getting the address of any wallet you created.

Use getLatestWallet() if you just want to get the address of the wallet you just generated.

With getWalletFromId() you can obtain the address of a given wallet. You need to the input the parameter '\_Id' to get it, which corresponds to the order in which you created your wallets (use '0' to get the first wallet you created, '1' for the second, and so on).
