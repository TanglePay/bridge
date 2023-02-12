//SPDX-License-Identifier: UNLICENSED

pragma solidity =0.8.17;

import "./multiSign.sol";

contract MultiSignWallet is MultiSign {
    struct Transfer {
        uint256 amount;
        address payable to;
        uint256 requiredCount;
        bool sent;
    }
    mapping(bytes32 => Transfer) transfers; // txid => Transfer
    mapping(address => mapping(bytes32 => bool)) isSent; // signer => txid => isSent

    event Deposit(
        address indexed sender,
        uint256 amount,
        bytes32 to,
        bytes32 chain
    );

    constructor(address[] memory _signers, uint8 _requireCount)
        MultiSign(_signers, _requireCount)
    {}

    // send to user
    // txid is the txid of target chain, it must be unique
    // only the MultiSignWallet can do this
    function send(
        bytes32 txid,
        uint256 amount,
        address payable to
    ) external onlySigner {
        require(!transfers[txid].sent, "sent over");
        if (transfers[txid].to == address(0)) {
            transfers[txid] = Transfer(amount, to, 0, false);
        } else {
            require(
                transfers[txid].amount == amount && transfers[txid].to == to,
                "invalid transfer"
            );
        }
        if (!isSent[msg.sender][txid]) {
            isSent[msg.sender][txid] = true;
            transfers[txid].requiredCount++;
        }

        if (transfers[txid].requiredCount >= requireCount) {
            transfers[txid].sent = true;
            (bool success, ) = to.call{value: amount}("");
            require(success, "transfer failed");
            return;
        }
    }

    // deposit to this contract
    // to is the address in the target chain
    // chain is the bridge chain's name
    function deposit(bytes32 to, bytes32 chain) external payable {
        emit Deposit(msg.sender, msg.value, to, chain);
    }
}
