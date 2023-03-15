// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
require("dotenv").config();

async function main() {
    const signers = ["0x273a0D884aA94EB1cD8735D7B1F1451fC70a1131", "0xfC0F8F40eCc0C180A707FdCe7c6FB8138705c785", "0xC4607f0F8337Ac925D4353ECf8e57f8057f6ce90"];
    const requireNum = 2;

    const MultiSignWallet = await hre.ethers.getContractFactory("MultiSignWallet");
    const msw = await MultiSignWallet.deploy(signers, requireNum);
    await msw.deployed();
    console.log(`MultiSignWallet deployed to ${msw.address}`);

    const wToken = "0x0eddA25a338e68E935112b23C6E8a30AC216AD74";
    const MultiSignERC20Wallet = await hre.ethers.getContractFactory("MultiSignERC20Wallet")
    const msew = await MultiSignERC20Wallet.deploy(signers, requireNum, wToken);
    await msew.deployed();
    console.log(`MultiSignERC20Wallet deployed to ${msew.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
