// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
    const signers = ["0x273a0D884aA94EB1cD8735D7B1F1451fC70a1131", "0xfC0F8F40eCc0C180A707FdCe7c6FB8138705c785", "0xC4607f0F8337Ac925D4353ECf8e57f8057f6ce90"];
    const requireNum = 2;

    const BridgeWrap = await hre.ethers.getContractFactory("BridgeWrap")
    const sETH = await BridgeWrap.deploy("Wrap MATIC", "sMATIC", 18, 1, signers, requireNum);
    await sETH.deployed();
    console.log(`sMATIC deployed to ${sETH.address}`);
    return;

    const sWBTC = await BridgeWrap.deploy("Wrap WBTC", "sWBTC", 8, 1, signers, requireNum);
    await sWBTC.deployed();
    console.log(`sWBTC deployed to ${sWBTC.address}`);

    const sMIOTA = await BridgeWrap.deploy("Wrap MIOTA", "sMIOTA", 6, 1010102, signers, requireNum);
    await sMIOTA.deployed();
    console.log(`sMIOTA deployed to ${sMIOTA.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
