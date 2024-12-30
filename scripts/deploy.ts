const hre = require("hardhat");

async function main() {
  const SampleContract = await hre.ethers.getContractFactory("SampleContract");
  const sampleContract = await SampleContract.deploy();

  await sampleContract.deployed();
  console.log("SampleContract deployed to:", sampleContract.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
