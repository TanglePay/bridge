// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
require("dotenv").config();

async function main() {
    const wbtc = await hre.ethers.getContractAt("WBTC", "0x0eddA25a338e68E935112b23C6E8a30AC216AD74")
    const b = await wbtc.approve("0x108f44932E5817eD8131261E1967233385cE39e9", 10000000000000000n)
    console.log(`WBTC approve ${b}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
