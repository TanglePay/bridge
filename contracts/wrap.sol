// SPDX-License-Identifier: GPL-3.0
pragma solidity =0.8.17;

import "./wrapERC20.sol";
import "./ownable.sol";
import "./multiSign.sol";

contract BridgeWrap is WrapERC20, Ownable, MultiSign {
    uint24 public constant FEE_DIV_CONST = 100000;
    uint24 public constant feeRate = 200; // it means 0.2% (feeRate / FEE_DIV_CONST * 100%)
    uint256 public  gasFee;
    uint256 public immutable GAS_FEE_UPPER;
    uint256 public feeSum;
    uint256 public immutable minUnwrapAmount;

    struct WrapTx {
        uint256 amount;
        address to;
        uint8 requiredCount;
        bool sent;
    }
    mapping(bytes32 => WrapTx) public wraps; // txid => WrapTx
    mapping(address => mapping(bytes32 => bool)) public isWrapped; // signer => txid => isWrapped

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
        uint256 _gasFee,
        uint256 gasFeeUpper,
        uint256 _minUnwrapAmount,
        address[] memory _signers,
        uint8 _requireCount
    ) WrapERC20(_name, _symbol, _decimal) MultiSign(_signers, _requireCount) {
        owner = msg.sender;
        gasFee = _gasFee;
        GAS_FEE_UPPER = gasFeeUpper;
        minUnwrapAmount = _minUnwrapAmount;
    }

    // mint ERC20 token to user
    // this is multSign
    function wrap(
        bytes32 txid,
        uint256 amount,
        address to
    ) external onlySigner {
        require(!wraps[txid].sent, "wrapped finished");
        require(!isWrapped[msg.sender][txid], "sender wrapped");
        if (wraps[txid].to == address(0)) {
            wraps[txid] = WrapTx(amount, to, 0, false);
        } else {
            require(
                wraps[txid].amount == amount && wraps[txid].to == to,
                "invalid wrap"
            );
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

    function unWrap(bytes32 to, bytes32 symbol, uint256 amount) public {
        _burn(msg.sender, amount);
        uint256 fee = (amount * feeRate) / FEE_DIV_CONST + gasFee;
        feeSum += fee;
        amount = amount - fee;
        require(amount >= minUnwrapAmount, "amount lower for gas fee");
        emit UnWrap(msg.sender, to, symbol, amount);
    }

    //withdraw the fee to dev team
    function withdrawFee(address to, uint256 fee) external {
        require(msg.sender == owner, "forbidden");
        feeSum -= fee;
        _mint(to, fee);
    }

    //unwrap the fee to dev team
    function unWrapFee(bytes32 to, bytes32 symbol, uint256 fee) external {
        require(msg.sender == owner, "forbidden");
        feeSum -= fee;
        emit UnWrap(owner, to, symbol, fee);
    }

    function setGasFee(uint256 newGasFee) external{
        require(msg.sender == owner, "forbidden");
        require(newGasFee <= GAS_FEE_UPPER, "too uppper");
        gasFee = newGasFee;
    }
}
