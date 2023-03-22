// SPDX-License-Identifier: GPL-3.0
pragma solidity =0.8.19;

import {WrapERC20} from "./wrapERC20.sol";
import {Ownable} from "./ownable.sol";
import {MultiSign} from "./multiSign.sol";
import {ReentrancyGuard} from "./lib/ReentrancyGuard.sol";

contract BridgeWrap is WrapERC20, Ownable, MultiSign, ReentrancyGuard {
    uint24 public constant FEE_DIV_CONST = 100000;
    uint24 public constant feeRate = 1000; // it means %1 (feeRate / FEE_DIV_CONST * 100%)
    uint256 public feeSum;
    uint256 public minUnWrapAmount;

    // 3 slots
    struct WrapTx {
        uint256 amount;
        uint8 requiredCount;
        address payable to;
        bool sent;
    }

    mapping(bytes32 => WrapTx) wraps; // txid => WrapTx
    mapping(address => mapping(bytes32 => bool)) isWrapped; // signer => txid => isWrapped

    event Wrap(address indexed to, uint256 amount);
    event UnWrap(
        address indexed from,
        bytes32 indexed to,
        bytes32 symbol,
        uint256 amount
    );

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimal,
        uint256 minAmount,
        address[] memory _signers,
        uint256 _requireCount
    ) WrapERC20(_name, _symbol, _decimal) MultiSign(_signers, _requireCount) {
        owner = msg.sender;
        minUnWrapAmount = minAmount;
    }

    // mint ERC20 token to user
    // this is multSign
    function wrap(
        bytes32 txid,
        uint256 amount,
        address payable to
    ) external onlySigner {
        if (wraps[txid].sent) revert("wrapped finished");
        // require(!wraps[txid].sent, "wrapped finished");
        if (isWrapped[msg.sender][txid]) revert("sender wrapped");
        // require(!isWrapped[msg.sender][txid], "sender wrapped");

        if (wraps[txid].to == address(0)) {
            wraps[txid] = WrapTx(amount, 0, to, false);

        } else {
            
        if (wraps[txid].amount != amount 
            && wraps[txid].to != to) 
                revert("invalid wrap");
        }

        if (!isWrapped[msg.sender][txid]) {
            isWrapped[msg.sender][txid] = true;
            wraps[txid].requiredCount++;
        }

        if (wraps[txid].requiredCount >= requireCount) {
            wraps[txid].sent = true;
            uint256 fee = (amount * feeRate) / FEE_DIV_CONST;
            feeSum += fee;
            amount -= fee;
            _mint(to, amount);
            emit Wrap(to, amount);
        }
    }

    function unWrap(bytes32 to, bytes32 _symbol, uint256 amount) external nonReentrant {
        if (minUnWrapAmount > amount) revert("amount low");
        // require(amount >= minUnWrapAmount, "amount low");
        _burn(msg.sender, amount);
        uint256 fee = (amount * feeRate) / FEE_DIV_CONST;
        feeSum += fee;
        emit UnWrap(msg.sender, to, _symbol, amount - fee);
    }

    //withdraw the fee to dev team
    function withdrawFee(address to, uint256 fee) external nonReentrant {
        if (msg.sender != owner) revert("forbidden");
        feeSum -= fee;
        _mint(to, fee);
    }

    //unwrap the fee to dev team
    function unWrapFee(bytes32 to, bytes32 _symbol, uint256 fee) external {
        if (msg.sender != owner) revert("forbidden");
        feeSum -= fee;
        emit UnWrap(owner, to, _symbol, fee);
    }
}
