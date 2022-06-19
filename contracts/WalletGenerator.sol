//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

import "./*Wallet.sol";

/** @title EVM wallet generator
 *  @author David Camps Novi
 *  @dev This contract uses a factory pattern to deploy a new wallet for each user
 */
contract WalletGenerator {


    mapping (address => mapping(uint256 => address) private s_wallets;
    /* Number of Wallets created by each User */
    mapping (address => uint256) s_numberOfWallets;

    event WalletCreate(address indexed owner, address indexed walletAddress, string type);

    /**
     *  @notice This is the function that will deploy a new wallet every time it's called.
     *  @dev The wallet addresses and Ids are stored in mappings so that users can get
     *  their wallet addresses. 
     */
    function createSimpleWallet() external {
        SimpleWallet newWallet = new SimpleWallet(msg.sender);
        uint256 nextWalletId = s_numberOfWallets[msg.sender];
        s_wallets[msg.sender][nextWalletId] = newWallet.address();
        s_numberOfWallets[msg.sender] += 1;
        emit WalletCreate(msg.sender, newWallet.address, "SimpleWallet")
    }

    function createDestroyableWallet() external {
        DestroyableWallet newWallet = new DestroyableWallet(msg.sender);
        uint256 nextWalletId = s_numberOfWallets[msg.sender];
        s_wallets[msg.sender][nextWalletId] = newWallet.address();
        s_numberOfWallets[msg.sender] += 1;
        emit WalletCreate(msg.sender, newWallet.address, "DestroyableWallet")
    }

    function createMultisigWallet(address[] memory _owners, _requiredConfirmations) external () {
        MultisigWallet newWallet = new MultisigWallet(_owners, _requiredConfirmations);
        uint256 nextWalletId = s_numberOfWallets[msg.sender];
        s_wallets[msg.sender][nextWalletId] = newWallet.address();
        s_numberOfWallets[msg.sender] += 1;
        emit WalletCreate(msg.sender, newWallet.address, "MultisigWallet")
    }

    /**
     *  @notice Use this function to get the address of your last created wallet
     */
    function getLatestWallet() external view returns (address) {
        uint256 latestId = s_numberOfWallets[msg.sender];
        return s_wallets[msg.sender][latestId];
    }

    function getWalletFromId(uint256 _Id) external view returns (address) {
        return s_wallets[msg.sender[_Id]];
    }

    function getAllWallets() external view returns (address[] memory addresses) {
        for (uint256 i; i < s_numberOfWallets[msg.sender], i++) {
            addresses.append(s_wallets[msg.sender][i]);
        }
        return addresses;
    }

}