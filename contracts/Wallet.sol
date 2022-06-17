//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

import "hardhat/console.sol";

error Wallet__Unauthorized();
error Wallet__ClosedWallet();
error Wallet__StatusNotPreDestroy();

/** @title EVM wallet
 *  @author David Camps Novi
 *  @dev This contract has some common functions used in a wallet
 */
contract Wallet {

    enum WalletStatus{
        CLOSED,
        PREDESTROY,
        OPEN,
    }
    
    WalletStatus public s_status;

    address private immutable i_owner

    event Recieved(address indexed sender, uint256 amount);
    event FundsTransfer(address indexed recipient, uint256 amount);
    event AllWithdraw(uint256 _amount);
    event WalletDelete(address recipient, uint256 amount)

    modifier onlyOwner {
        if (msg.sender != i_owner) revert Wallet__Unauthorized();
        _;
    }

    modifier walletOpen {
        if (s_status != WalletStatus.OPEN) revert Wallet__ClosedWallet();
        _;
    }

    constructor(address _owner) {
        i_owner = _owner;
        s_status = WalletStatus.OPEN;
    }

    receive() external payable { //msg.data is empty
        if (s_status != WalletStatus.OPEN) revert Wallet__ClosedWallet();
        emit Recieved(msg.sender, msg.value);
    }

    fallback() external payable { //msg.data is not empty
        if (s_status != WalletStatus.OPEN) revert Wallet__ClosedWallet();
        emit Recieved(msg.sender, msg.value);
    }

    /**
     *  @notice This function transfers some funds from this wallet to another address.
     */
    function transferFunds(uint256 _amount, address _recipient) external onlyOwner {
        payable(_recipient).transfer(_amount);
        event FundsTransfer(_recipient, _amount)
    }

    /**
     *  @notice This function withdraws the whole balance of this wallet to the address 
     *  that deployed it.
     */
    function withdrawAll(uint256 _amount) external onlyOwner {
        payable(msg.sender).transfer(address(this).balance());
        emit AllWithdraw(_amount);
    }

    /**
     *  @notice This wallet comes with a selfdestruct functionality. In order to add extra
     *  protection, this is a two-step process: first call preDestroy(), then deleteWallet().
     *  Use the function cancelPreDestroy() if you want to restore the wallet to the previous
     *  status. Once the wallet is destroyed, all its funds will be send to a given address and
     *  the wallet will become inoperative.
     *  @dev To control the status of the wallet, an enum "status" has been generated. The
     *  function deleteWallet() can only be called if the status is PREDESTROY. The status 
     *  of the wallet can be checked with the function getStatus().
     *  @param _recipient Is the address to which the funds of this wallet will be sent.
     */
    function deleteWallet (address _recipient) onlyOwner walletOpen {
        if (s_status != WalletStatus.PREDESTROY) revert Wallet__StatusNotPreDestroy();
        emit WalletDelete(_recipient, address(this).balance())
        selfdestruct(payable(_recipient));
    }

    function preDestroy () onlyOwner {
        status = WalletStatus.PREDESTROY;
    }

    function cancelPreDestroy () onlyOwner {
        status = WalletStatus.OPEN;
    }

    /**
     *  @notice This function returns the address of your address.
     */
    function getBalance() external view returns (uint256) {
        return (address(this).balance())
    }

    /**
     *  @dev This function will return '2' if the wallet is in its steady state and '1'
     *  if it's in PREDESTROY status.
     */
    function getStatus() external view returns (uint256) {
        return s_status;
    }

}
