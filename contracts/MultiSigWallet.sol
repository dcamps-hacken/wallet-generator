//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

error MultiSigWallet__Unauthorized();
error MultiSigWallet__AlreadyApproved();
error MultiSigWallet_NotEnoughConfirmations();

contract MultiSigWallet {
    struct Transaction {
        uint256 amount;
        address recipient;
        bytes data;
        uint256 confirmations;
        bool executed;
    }

    uint256 immutable private i_nextId;
    mapping(uint256 => Transaction) private transactions;
    mapping(address => bool) private owners;
    mapping(uint256 => mapping(address => bool)) approvals;

    event Submit(uint256 transactionId, address user);
    event Approve(uint256 transactionId, address user);
    event Transact(uint256 transactionId, address user);

    modifier onlyOwners() {
        if (owners[msg.sender] != true) revert MultiSigWallet__Unauthorized();
        _;
    }

    constructor(address owner1, address owner2) {
        owners[msg.sender] = true;
        owners[owner1] = true;
        owners[owner2] = true;
        i_nextId = 0;
    }

    function submit(
        uint256 _amount,
        address _recipient,
        bytes _data
    ) external onlyOwners {
        newTransaction = new Transaction({
            amount: _amount,
            recipient: _recipient,
            data: _data,
            confirmations: 1,
            executed: false
        });
        transactions[s_nextId] = newTransaction;
        approvals[s_nextId][msg.sender] = true;
        emit Submit(s_nextId, msg.sender);
        s_nextId += 1;
    }

    function approve(uint256 _transactionId) external onlyOwners {
        if(approvals[_transactionId][msg.sender] != false) revert MultiSigWallet__AlreadyApproved();
        transactions[_transactionId].confirmations += 1;
        emit Approve (_transactionId, msg.sender);
    }

    function transact(uint256 _transactionId) external onlyOwners {
        if (transactions[_transactionId].confirmations < 2) revert MultiSigWallet_NotEnoughConfirmations();
        emit Transact (_transactionId, msg.sender)

    }
}
