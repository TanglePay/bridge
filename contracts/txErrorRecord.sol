//SPDX-License-Identifier: UNLICENSED

pragma solidity =0.8.17;
import "./ownable.sol";

contract BridgeTxErrorRecord is Ownable {
    constructor() {
        owner = msg.sender;
    }

    struct OrderFailRecord {
        int8 d; // 1: wrap failed, -1: unWrap failed
        bytes32 fromCoin; // from coin's symbol
        bytes32 toCoin; // to coin's symbol
        bytes32[] toFailTxes;
    }

    mapping(bytes32 => OrderFailRecord) internal failedTxes; // txid => UnWrapFailRecord
    event UnWrapFailed(bytes32 txid, bytes32 from, bytes32 to); //txid is the user's successful txid
    event WrapFailed(bytes32 txid, bytes32 from, bytes32 to);

    function submitFailedOrder(
        int8 d,
        bytes32 from,
        bytes32 txid,
        bytes32 to,
        bytes32 failedTxid
    ) external {
        require(msg.sender == owner);
        require(d == 1 || d == -1, "d error");
        OrderFailRecord storage r = failedTxes[txid];
        if (r.d == 0) {
            r.d = d;
            r.fromCoin = from;
            r.toCoin = to;
        } else {
            require(
                r.d == d && r.fromCoin == from && r.toCoin == to,
                "param error"
            );
        }
        for (uint256 i = 0; i < r.toFailTxes.length; i++) {
            require(r.toFailTxes[i] != failedTxid, "txid exist");
        }
        r.toFailTxes.push(failedTxid);
        if (d == 1) {
            emit WrapFailed(txid, from, to);
        } else {
            emit UnWrapFailed(txid, from, to);
        }
    }

    function getFailTxes(
        bytes32 txid
    ) external view returns (bytes32[] memory) {
        return failedTxes[txid].toFailTxes;
    }
}
