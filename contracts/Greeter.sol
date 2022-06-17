//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

import "hardhat/console.sol";

error Wallet_Unauthorized();
error Wallet_ClosedWallet();
error Wallet_StatusNotPreDestroy();

contract Wallet {

    enum WalletStatus{
        CLOSED,
        PREDESTROY,
        OPEN,
    }
    
    Wallet status public status;

    address private immutable i_owner

    modifier onlyOwner {
        if (msg.sender != i_owner) revert Wallet_Unauthorized();
        _;
    }

    modifier walletOpen {
        if (status != WalletStatus.OPEN) revert Wallet_ClosedWallet();
        _;
    }

    constructor(address _owner) {
        i_owner = _owner;
        status = WalletStatus.OPEN;
    }

    receive() external payable { //msg.data is empty
        if (status != WalletStatus.OPEN) revert Wallet_ClosedWallet();
    }

    fallback() external payable { //msg.data is not empty
        if (status != WalletStatus.OPEN) revert Wallet_ClosedWallet();
    }

    function transferFunds(uint256 _amount, address _recipient) external onlyOwner {
        payable(_recipient).transfer(_amount);
    }

    function withdrawAll(uint256 _amount) external onlyOwner {
        payable(msg.sender).transfer(address(this).balance());
    }

    function preDestroy () onlyOwner {
        status = WalletStatus.PREDESTROY;
    }

    function cancelPreDestroy () onlyOwner {
        status = WalletStatus.OPEN;
    }

    function deleteWallet (address _recipient) onlyOwner walletOpen {
        if (status != WalletStatus.PREDESTROY) revert Wallet_StatusNotPreDestroy();
        selfdestruct(payable(_recipient));
    }

    function getBalance() external returns (uint256) {
        return this.balance()
    }

}
