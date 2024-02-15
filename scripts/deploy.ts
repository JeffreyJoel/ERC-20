import { ethers } from "hardhat";

async function main() {

  const Token = await ethers.getContractFactory("Token");
  const token = await Token.deploy("JoeToken", "JTK", 1000000000000000)

  await token.waitForDeployment();

  console.log(
    `JoeToken deployed to${token.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
