// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
require("dotenv").config();

async function main() {
  //const signers = ["0x273a0D884aA94EB1cD8735D7B1F1451fC70a1131", "0xfC0F8F40eCc0C180A707FdCe7c6FB8138705c785", "0xC4607f0F8337Ac925D4353ECf8e57f8057f6ce90"];
  //const requireNum = 2;
  const signers = ["0xEAFeeDe1634C730767f8BB52B228409A97e20834", "0x520da6bE41DdD56719b96685aa8a16f97c6907cA", "0xbC6FBA88AD1F470494095C793cEcB5AcF956f09a", "0x458a8E1cc5da9a205AFa66C3A6Fba40abf974203", "0x0cd6770bec3a5984f518b6fb296b394ad27b2e14", "0xad123dddd5128e43b807faa816a88487f46700b4"];
  const requireNum = 4;

  const BridgeWrap = await hre.ethers.getContractFactory("BridgeWrap")
  const sMATIC = await BridgeWrap.deploy("Wrap MATIC", "sMATIC", 18, 1, signers, requireNum);
  await sMATIC.deployed();
  console.log(`sMATIC deployed to ${sMATIC.address}`);

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
