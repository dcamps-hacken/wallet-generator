//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

error SimpleWallet__Unauthorized();

/** @title EVM wallet
 *  @author David Camps Novi
 *  @dev This contract has some common functions used in a wallet
 */
contract SimpleWallet {
    address private immutable i_owner;

    event FundsReceived(address indexed sender, uint256 amount);
    event FundsTransfer(address indexed recipient, uint256 amount);
    event AllWithdraw(uint256 _amount);
    event WalletDelete(address recipient, uint256 amount);

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert SimpleWallet__Unauthorized();
        _;
    }

    constructor(address _owner) {
        i_owner = _owner;
    }

    receive() external payable {
        emit FundsReceived(msg.sender, msg.value);
    }

    fallback() external payable {
        emit FundsReceived(msg.sender, msg.value);
    }

    /**
     *  @notice This function transfers some funds from this wallet to another address.
     */
    function transferFunds(uint256 _amount, address _recipient)
        external
        onlyOwner
    {
        payable(_recipient).transfer(_amount);
        emit FundsTransfer(_recipient, _amount);
    }

    /**
     *  @notice This function withdraws the whole balance of this wallet to the address
     *  that deployed it.
     */
    function withdrawAll(uint256 _amount) external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
        emit AllWithdraw(_amount);
    }

    /**
     *  @notice This function returns the address of your address.
     */
    function getBalance() external view returns (uint256) {
        return (address(this).balance);
    }
}
