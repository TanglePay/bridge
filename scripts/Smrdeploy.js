// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  //const signers = ["0x273a0D884aA94EB1cD8735D7B1F1451fC70a1131", "0xfC0F8F40eCc0C180A707FdCe7c6FB8138705c785", "0xC4607f0F8337Ac925D4353ECf8e57f8057f6ce90"];
  //const requireNum = 2;
  //const signers = ["0x380dF538Ab2587B11466d07ca5c671d33497d5Ca", "0x3Fdd4B2d69848F74E44765e6AD423198bdBD94fa", "0xfb6e712F4f71D418A298EBe239889A2496f1359b", "0x5e80cf0C104D2D4f685A15deb65A319e95dd80dD", "0x9dcb974Cf7522F91F2Add8303e7BCB2221063c48", "0xeBbe638eF6dF4A3837435bB44527f8D9BA9CF981"];
  //const requireNum = 4;
  const signers = ["0xA8E2127A179a8e0D142eD8c3287b9526882C560D"];
  const requireNum = 1;

  const BridgeWrap = await hre.ethers.getContractFactory("BridgeWrap")
  const sMATIC = await BridgeWrap.deploy("Wrap SOON", "sSOON", 6, 10000, 800000, 1, signers, requireNum);
  await sMATIC.deployed();
  console.log(`sSOON deployed to ${sMATIC.address}`);
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
