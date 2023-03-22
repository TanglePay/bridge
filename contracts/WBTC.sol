// SPDX-License-Identifier: GPL-3.0
pragma solidity =0.8.19;

import {WrapERC20} from "./wrapERC20.sol";
import {Ownable} from "./ownable.sol";
import {MultiSign} from "./multiSign.sol";

contract WBTC is WrapERC20, Ownable {
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimal
    ) WrapERC20(_name, _symbol, _decimal) {
        owner = msg.sender;
        totalSupply = 10000000000 * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
    }

    mapping(address => uint256) public faucetLastOf;
    uint256 public faucetAmount = 100;
    event Faucet(address indexed sender, address indexed to, uint256 amount);

    function setFaucetAmount(uint256 amount) external returns (bool) {
        require(owner == msg.sender);
        faucetAmount = amount;
        return true;
    }

    function faucet(address to) external returns (bool) {
        require(block.timestamp > faucetLastOf[to] + 600, "time wait");
        uint256 amount = faucetAmount * (10 ** decimals);
        _mint(to, amount);
        faucetLastOf[to] = block.timestamp;
        emit Faucet(msg.sender, to, amount);
        return true;
    }
}
