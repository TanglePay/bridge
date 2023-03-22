//SPDX-License-Identifier: UNLICENSED

pragma solidity =0.8.19;

import {IERC20} from "./interfaces/IERC20.sol";
import {MultiSign} from "./multiSign.sol";
import {ReentrancyGuard} from "./lib/ReentrancyGuard.sol";

contract MultiSignERC20Wallet is MultiSign, ReentrancyGuard {
    IERC20 public immutable token; // the token contract address to wrap

    // 3 slots
    struct Transfer {
        uint256 amount;
        uint256 requiredCount;
        address payable to;
        bool sent;
    }
    mapping(bytes32 => Transfer) transfers; // txid => Transfer
    mapping(address => mapping(bytes32 => bool)) isSent; // signer => txid => isSent

    event Wrap(
        address indexed sender,
        address indexed to,
        bytes32 symbol,
        uint256 amount
    );

    constructor(
        address[] memory _signers,
        uint256 _requireCount,
        address _token
    ) MultiSign(_signers, _requireCount) {
        token = IERC20(_token);
    }

    // send to user
    // txid is the txid of target chain, it must be unique
    // only the MultiSignWallet can do this
    function send(
        bytes32 txid,
        uint256 amount,
        address payable to
    ) external onlySigner {
        // require(!transfers[txid].sent, "sent over");
        if (transfers[txid].sent) revert("sent over");

        if (transfers[txid].to == address(0)) {
            transfers[txid] = Transfer(amount, 0, to, false);
        } else {
            if (transfers[txid].amount != amount && 
                transfers[txid].to != to) 
                    revert("invalid transfer");
            /*        
            require(
                transfers[txid].amount == amount && transfers[txid].to == to,
                "invalid transfer"
            );
            */
        }
        if (!isSent[msg.sender][txid]) {
            isSent[msg.sender][txid] = true;
            transfers[txid].requiredCount++;
        }

        if (transfers[txid].requiredCount >= requireCount) {
            transfers[txid].sent = true;
            token.transfer(to, amount);
        }
    }

    // deposit erc20 token to this contract to wrap token in the target chain
    // to is the address in the target chain
    // symobl is the bridge token symbol in the target chain
    function wrap(address to, bytes32 symbol, uint256 amount) external nonReentrant {
        token.transferFrom(msg.sender, address(this), amount);
        emit Wrap(msg.sender, to, symbol, amount);
    }
}
