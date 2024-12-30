import { ethers } from "hardhat";
import { expect } from "chai";
import { Contract, Signer } from "ethers";

describe("SampleContract", function () {
  let SampleContract: Contract;
  let sampleContract: Contract;
  let owner: Signer;
  let addr1: Signer;

  beforeEach(async function () {
    [owner, addr1] = await ethers.getSigners();
    const SampleContractFactory = await ethers.getContractFactory("SampleContract");
    sampleContract = await SampleContractFactory.deploy();
    await sampleContract.deployed();
  });

  it("Should set the owner correctly", async function () {
    const ownerAddress = await owner.getAddress();
    expect(await sampleContract.owner()).to.equal(ownerAddress);
  });

  it("Should update the string when paid 1 ether", async function () {
    const addr1Address = await addr1.getAddress();
    await sampleContract.connect(addr1).updateString("New String", { value: ethers.utils.parseEther("1") });
    expect(await sampleContract.myString()).to.equal("New String");
  });

  it("Should not update the string if not paid 1 ether", async function () {
    await expect(
      sampleContract.connect(addr1).updateString("New String", { value: ethers.utils.parseEther("0.5") })
    ).to.be.revertedWith("Requires 1 ether to update the string");
  });

  it("Should accept donations", async function () {
    const addr1Address = await addr1.getAddress();
    await sampleContract.connect(addr1).donate({ value: ethers.utils.parseEther("2") });
    const contractBalance = await ethers.provider.getBalance(sampleContract.address);
    const totalDonations = await sampleContract.totalDonations();

    expect(contractBalance).to.equal(ethers.utils.parseEther("2"));
    expect(totalDonations).to.equal(ethers.utils.parseEther("2"));
  });
});
