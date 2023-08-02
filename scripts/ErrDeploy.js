// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
    const BridgeTxErrorRecord = await hre.ethers.getContractFactory("BridgeTxErrorRecord")
    const txErrRecord = await BridgeTxErrorRecord.deploy();
    await txErrRecord.deployed();
    console.log(`BridgeTxErrorRecord deployed to ${txErrRecord.address}`);
    return;

    const from = "0x734d494f54410000000000000000000000000000000000000000000000000000";
    const to = "0x41544f4900000000000000000000000000000000000000000000000000000000";
    const amount = "1200000";
    const txid = "0x0000000000000000000000000000000000000000000000000000000000000001";
    const failedTx1 = "0x0000000000000000000000000000000000000000000000000000000000000001";
    const failedTx2 = "0x0000000000000000000000000000000000000000000000000000000000000002";
    await txErrRecord.submitFailedOrder(-1, from, txid, to, amount, failedTx1);
    await txErrRecord.submitFailedOrder(-1, from, txid, to, amount, failedTx2);
    const data = await txErrRecord.failedTxes(txid);
    console.log(`txid : ${data}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
