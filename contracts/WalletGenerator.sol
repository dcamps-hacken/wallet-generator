//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

import "./Wallet.sol";

/** @title EVM wallet generator
 *  @author David Camps Novi
 *  @dev This contract uses a factory pattern to deploy a new wallet for each user
 */
contract WalletGenerator {


    mapping (address => address) private s_wallets;

    event WalletCreate(address indexed owner, address indexed walletAddress);

    /**
     *  @notice This is the function that will deploy a new wallet every time it's called.
     *  @dev The wallet address is stored in a mapping so that every user can get it. Note 
     *  that only the last created wallet address will remain in the mapping since it is 
     *  overwritten every time.
     *  @return It returns the address of the created address
     */
    function createWallet() external returns (address) {
        Wallet newWallet = new Wallet(msg.sender);
        s_wallets[msg.sender] = newWallet.address;
        emit WalletCreate(msg.sender, newWallet.address)
        return newWallet.address; //do I need this if there is an event?
    }

    /**
     *  @notice Use this function to get the address of your last created wallet
     */
    function getWallet() external view returns (address) {
        return s_wallets[msg.sender];
    }

}