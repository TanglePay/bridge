//SPDX-License-Identifier: UNLICENSED

pragma solidity =0.8.17;
import "./ownable.sol";

contract BridgeTxErrorRecord is Ownable {
    constructor() {
        owner = msg.sender;
    }

    struct OrderFailRecord {
        int8 d; // 1: wrap failed, -1: unWrap failed
        bytes16 fromCoin;
        uint256 amount;
        bytes16 toCoin;
        bytes32[] toFailTxes;
    }

    mapping(bytes32 => OrderFailRecord) public failedTxes; // txid => UnWrapFailRecord
    event UnWrapFailed(bytes32 txid); //txid is the user's successful txid
    event WrapFailed(bytes32 txid);

    function submitFailedOrder(
        int8 d,
        bytes16 from,
        bytes32 txid,
        bytes16 to,
        uint256 amount,
        bytes32 failedTxid
    ) external {
        require(amount > 0, "amount zero");
        require(d == 1 || d == -1, "d error");
        OrderFailRecord storage r = failedTxes[txid];
        if (r.amount == 0) {
            r.d = d;
            r.fromCoin = from;
            r.toCoin = to;
            r.amount = amount;
        } else {
            require(
                r.amount == amount && r.fromCoin == from && r.toCoin == to,
                "param error"
            );
        }
        for (uint256 i = 0; i < r.toFailTxes.length; i++) {
            require(r.toFailTxes[i] != failedTxid, "txid exist");
        }
        r.toFailTxes.push(failedTxid);
        if (d == 1) {
            emit WrapFailed(txid);
        } else {
            emit UnWrapFailed(txid);
        }
    }
}
