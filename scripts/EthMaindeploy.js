// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
require("dotenv").config();

async function main() {
    const signers = ["0x380dF538Ab2587B11466d07ca5c671d33497d5Ca", "0x3Fdd4B2d69848F74E44765e6AD423198bdBD94fa", "0xfb6e712F4f71D418A298EBe239889A2496f1359b", "0x5e80cf0C104D2D4f685A15deb65A319e95dd80dD", "0x9dcb974Cf7522F91F2Add8303e7BCB2221063c48", "0xeBbe638eF6dF4A3837435bB44527f8D9BA9CF981"];
    const requireNum = 4;

    const MultiSignWallet = await hre.ethers.getContractFactory("MultiSignWallet");
    const msw = await MultiSignWallet.deploy(signers, requireNum);
    await msw.deployed();
    console.log(`MultiSignWallet ETH deployed to ${msw.address}`);

    const wToken = "0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599";
    const MultiSignERC20Wallet = await hre.ethers.getContractFactory("MultiSignERC20Wallet")
    const msew = await MultiSignERC20Wallet.deploy(signers, requireNum, wToken);
    await msew.deployed();
    console.log(`MultiSignERC20Wallet WBTC deployed to ${msew.address}`);

    const wbtc = await hre.ethers.getContractAt("WBTC", wToken)
    const b = await wbtc.approve(msew.address, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFn)
    console.log(`WBTC approve ${b}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
