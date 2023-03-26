//SPDX-License-Identifier: UNLICENSED

pragma solidity =0.8.17;
import "./ownable.sol";

contract BridgeTxErrorRecord is Ownable {
    constructor() {
        owner = msg.sender;
    }

    function unWrap() external {}

    function wrap() external {}
}
