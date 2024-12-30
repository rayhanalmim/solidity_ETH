import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@typechain/hardhat";

const config: HardhatUserConfig = {
  solidity: "0.8.22",
  typechain: {
    outDir: "typechain-types", // Output directory for TypeChain bindings
    target: "ethers-v5",       // Generate bindings compatible with ethers.js
  },
};

export default config;
