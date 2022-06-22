//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

import "./SimpleWallet.sol";
import "./DestroyableWallet.sol";
import "./MultisigWallet.sol";

/** @title EVM wallet generator
 *  @author David Camps Novi
 *  @dev This contract uses a factory pattern to deploy a new wallet for each user
 */
contract WalletGenerator {
    mapping(address => mapping(uint256 => address)) public s_wallets;
    /* Number of Wallets created by each User */
    mapping(address => uint256) public s_numberOfWallets;

    event WalletCreate(
        address indexed owner,
        address indexed walletAddress,
        string walletType
    );

    /**
     *  @notice This is the function that will deploy a new wallet every time it's called.
     *  @dev The wallet addresses and Ids are stored in mappings so that users can get
     *  their wallet addresses.
     */
    function createSimpleWallet() external {
        SimpleWallet newWallet = new SimpleWallet(msg.sender);
        uint256 nextWalletId = s_numberOfWallets[msg.sender];
        s_wallets[msg.sender][nextWalletId] = address(newWallet);
        s_numberOfWallets[msg.sender] += 1;
        emit WalletCreate(msg.sender, address(newWallet), "SimpleWallet");
    }

    function createDestroyableWallet() external {
        DestroyableWallet newWallet = new DestroyableWallet(msg.sender);
        uint256 nextWalletId = s_numberOfWallets[msg.sender];
        s_wallets[msg.sender][nextWalletId] = address(newWallet);
        s_numberOfWallets[msg.sender] += 1;
        emit WalletCreate(msg.sender, address(newWallet), "DestroyableWallet");
    }

    function createMultisigWallet(
        address[] memory _owners,
        uint256 _requiredConfirmations
    ) external {
        MultisigWallet newWallet = new MultisigWallet(
            _owners,
            _requiredConfirmations
        );
        uint256 nextWalletId = s_numberOfWallets[msg.sender];
        s_wallets[msg.sender][nextWalletId] = address(newWallet);
        s_numberOfWallets[msg.sender] += 1;
        emit WalletCreate(msg.sender, address(newWallet), "MultisigWallet");
    }

    /**
     *  @notice Use this function to get the address of your last created wallet
     */
    function getLatestWallet() external view returns (address) {
        uint256 latestId = s_numberOfWallets[msg.sender] - 1;
        return s_wallets[msg.sender][latestId];
    }

    function getWalletFromId(uint256 _Id) external view returns (address) {
        return s_wallets[msg.sender][_Id];
    }
}
