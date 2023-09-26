// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
    const signers = ["0xfb6e712F4f71D418A298EBe239889A2496f1359b", "0x380dF538Ab2587B11466d07ca5c671d33497d5Ca", "0x3Fdd4B2d69848F74E44765e6AD423198bdBD94fa", "0x5e80cf0C104D2D4f685A15deb65A319e95dd80dD", "0x9dcb974Cf7522F91F2Add8303e7BCB2221063c48", "0xeBbe638eF6dF4A3837435bB44527f8D9BA9CF981"];
    const requireNum = 4;

    const BridgeWrap = await hre.ethers.getContractFactory("BridgeWrap")

    let gasFee = 3000000000000000n;
    let gasFeeUpper = 60000000000000000n;
    let minUnwrapAmount = 1;
    const sMATIC = await BridgeWrap.deploy("Wrap ETH", "sETH", 18, gasFee, gasFeeUpper, minUnwrapAmount, signers, requireNum);
    await sMATIC.deployed();
    console.log(`sETH deployed to ${sMATIC.address}`);

    gasFee = 20000;
    gasFeeUpper = 600000;
    minUnwrapAmount = 1;
    const sWBTC = await BridgeWrap.deploy("Wrap WBTC", "sBTC", 8, gasFee, gasFeeUpper, minUnwrapAmount, signers, requireNum);
    await sWBTC.deployed();
    console.log(`sBTC deployed to ${sWBTC.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
