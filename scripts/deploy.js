// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
require("dotenv").config();

async function main() {
  const signers = ["0xEAFeeDe1634C730767f8BB52B228409A97e20834", "0x520da6bE41DdD56719b96685aa8a16f97c6907cA", "0xbC6FBA88AD1F470494095C793cEcB5AcF956f09a", "0x458a8E1cc5da9a205AFa66C3A6Fba40abf974203", "0x273a0D884aA94EB1cD8735D7B1F1451fC70a1131", "0xC4607f0F8337Ac925D4353ECf8e57f8057f6ce90"];
  const requireNum = 4;
  const MultiSignWallet = await hre.ethers.getContractFactory("MultiSignWallet");
  const msw = await MultiSignWallet.deploy(signers, requireNum);
  await msw.deployed();
  console.log(`MultiSignWallet deployed to ${msw.address}`);

  const wToken = "0xCB03Ebd74417AA792fC68a750F35c7b8F585027B";
  const MultiSignERC20Wallet = await hre.ethers.getContractFactory("MultiSignERC20Wallet")
  const msew = await MultiSignERC20Wallet.deploy(signers, requireNum, wToken);
  await msew.deployed();
  console.log(`MultiSignERC20Wallet deployed to ${msew.address}`);

  const WrapERC20 = await hre.ethers.getContractFactory("WrapERC20")
  const werc20 = await WrapERC20.deploy("SETH", 18);
  await werc20.deployed();
  console.log(`WrapERC20 deployed to ${werc20.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
