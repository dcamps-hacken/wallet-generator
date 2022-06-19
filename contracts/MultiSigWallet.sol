//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

error MultisigWallet__Unauthorized();
error MultisigWallet__AlreadyApproved();
error MultisigWallet_NotEnoughConfirmations();

contract MultisigWallet {

    struct Tx {
        uint256 amount;
        address recipient;
        uint256 confirmations;
        bool executed;
    }

    uint256 private nextTxId;
    uint256 private requiredConfirmations;
    mapping(uint256 => Tx) private s_txs;
    mapping(address => bool) private s_owners;
    mapping(uint256 => mapping(address => bool)) s_approvals;

    event FundsReceived(address indexed sender, uint256 amount);
    event TxSubmit(uint256 txId, address requester);
    event TxApprove(uint256 txId, address approver);
    event TxSend(uint256 txId, address sender);

    modifier onlyOwners() {
        if (s_owners[msg.sender] != true) revert MultisigWallet__Unauthorized();
        _;
    }

    constructor(address[] memory _owners, uint256 _requiredConfirmations) {
        for (uint i; i < _owners.length(); i++){
            s_owners[_owners[i]] = true;
        }
        requiredConfirmations = _requiredConfirmations;
    }

    receive() external payable { //msg.data is empty
        emit FundsReceived(msg.sender, msg.value);
    }

    fallback() external payable { //msg.data is not empty
        emit FundsReceived(msg.sender, msg.value);
    }

    function submitTx(
        uint256 _amount,
        address _recipient,
        bytes _data
    ) external onlyOwners {
        s_txs[nextTxId] = Transaction({
            amount: _amount,
            recipient: _recipient,
            confirmations: 1,
            executed: false
        });
        s_approvals[nextTxId][msg.sender] = true;
        emit TxSubmit(nextTxId, msg.sender);
        nextTxId += 1;
    }

    function approveTx(uint256 _txId) external onlyOwners {
        if(approvals[_txId][msg.sender] != false) revert MultisigWallet__AlreadyApproved();
        s_txs[_txId].confirmations += 1;
        emit TxApprove (_txId, msg.sender);
    }

    function sendTx(uint256 _transactionId) external onlyOwners {
        if (s_txs[_txId].confirmations < i_requiredConfirmations) revert MultisigWallet_NotEnoughConfirmations();
        address payable recipient = s_txs[_txId].recipient;
        uint256 amount = s_txs[_txId].amount;
        recipient.transfer(amount);
        emit TxSend (_txId, msg.sender)
    }

    function addOwner(address _newOwner) external onlyOwners {
        s_owners[_newOwner] = true;
    }

    function removeOwner(address _newOwner) external onlyOwners {
        s_owners[_newOwner] = false;
    }

    function changeConfirmations(uint256 _newConfirmations) {
        requiredConfirmations = _newConfirmations;
    }

    function getBalance() external view returns (uint256) {
        return (address(this).balance())
    }
}
