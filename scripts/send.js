// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
require("dotenv").config();

async function main() {
    const user = "0x2c61a1fc43a66a57d0C889BeB5d47EEF5Feb99F3";
    let erc20 = await hre.ethers.getContractAt("WBTC", "0x1F8E35099025EE03c89872D80CBb082ce2aBF632")
    let b = await erc20.transfer(user, 10000000000000000n)
    console.log(`transfer ${b}`);

    erc20 = await hre.ethers.getContractAt("WBTC", "0x3E3c8701EF91299F235B29535A28B94Ec02236E9")
    b = await erc20.transfer(user, 100000000000000000000000000n)
    console.log(`transfer ${b}`);

    erc20 = await hre.ethers.getContractAt("WBTC", "0x0F6Fd00E015080E8D8180D263d1E82270D00F500")
    b = await erc20.transfer(user, 100000000000000000000000000n)
    console.log(`transfer ${b}`);

    erc20 = await hre.ethers.getContractAt("WBTC", "0x7EF810B1D5d52136d8bAafd2cD173098886476a5")
    b = await erc20.transfer(user, 100000000000000000000000000n)
    console.log(`transfer ${b}`);

    erc20 = await hre.ethers.getContractAt("WBTC", "0x0b8207346701F551E5384175ecc69381627361F2")
    b = await erc20.transfer(user, 100000000000000000000000000n)
    console.log(`transfer ${b}`);

    erc20 = await hre.ethers.getContractAt("WBTC", "0xa885FdE6825a07A6413CDAe511Fe446289C863FE")
    b = await erc20.transfer(user, 100000000000000000000000000n)
    console.log(`transfer ${b}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
