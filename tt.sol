//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.7;
import "./interfaces/IERC20.sol";

contract TokenERC20 is IERC20 {
    string public override name = "Test Token 3";
    string public override symbol = "TT3";
    uint8 public override decimals = 6;
    uint256 public override totalSupply;
    address public minter;

    // 建立映射 地址对应了 uint' 便是他的余额
    mapping(address => uint256) public override balanceOf;
    // 地址对应余额
    mapping(address => mapping(address => uint256)) public override allowance;

    event Mint(address indexed sender, uint256 amount);

    // 这里是构造函数, 实例创建时候执行
    constructor() {
        totalSupply = 10000000000 * 10**uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        minter = msg.sender;
    }

    function mint(uint256 amount) public {
        require(minter == msg.sender);
        balanceOf[minter] += amount;
        emit Mint(msg.sender, amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 value
    ) private {
        allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function _transfer(
        address from,
        address to,
        uint256 value
    ) private {
        balanceOf[from] -= value;
        balanceOf[to] += value;
        emit Transfer(from, to, value);
    }

    function approve(address spender, uint256 value)
        external
        override
        returns (bool)
    {
        _approve(msg.sender, spender, value);
        return true;
    }

    function transfer(address to, uint256 value)
        external
        override
        returns (bool)
    {
        _transfer(msg.sender, to, value);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external override returns (bool) {
        if (allowance[from][msg.sender] != type(uint256).max) {
            allowance[from][msg.sender] -= value;
        }
        _transfer(from, to, value);
        return true;
    }

    mapping(address => uint256) public faucetLastOf;
    uint256 public faucetAmount = 100;
    event Faucet(address indexed sender, address indexed to, uint256 amount);

    function setFaucetAmount(uint256 amount) external returns (bool) {
        require(minter == msg.sender);
        faucetAmount = amount;
        return true;
    }

    function faucet(address to) external returns (bool) {
        require(block.timestamp > faucetLastOf[to] + 600, "time wait");
        uint256 amount = faucetAmount * (10**decimals);
        balanceOf[to] += amount;
        faucetLastOf[to] = block.timestamp;
        emit Faucet(msg.sender, to, amount);
        return true;
    }
}
