// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
    const sETH = "0xa158A39d00C79019A01A6E86c56E96C461334Eb0"
    const sBTC = "0x1cDF3F46DbF8Cf099D218cF96A769cea82F75316"
    const sSOON = "0x3C844FB5AD27A078d945dDDA8076A4084A76E513"
    var BridgeWrap = await hre.ethers.getContractAt("BridgeWrap", sETH)
    await BridgeWrap.transferOwner("0x5A6A7Bb92822e06B8faFf70E173c3ae90b583e1f")
    console.log(`owner change ${BridgeWrap.address}`);

    var BridgeWrap = await hre.ethers.getContractAt("BridgeWrap", sBTC)
    await BridgeWrap.transferOwner("0x5A6A7Bb92822e06B8faFf70E173c3ae90b583e1f")
    console.log(`owner change ${BridgeWrap.address}`);

    var BridgeWrap = await hre.ethers.getContractAt("BridgeWrap", sSOON)
    await BridgeWrap.transferOwner("0x5A6A7Bb92822e06B8faFf70E173c3ae90b583e1f")
    console.log(`owner change ${BridgeWrap.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
