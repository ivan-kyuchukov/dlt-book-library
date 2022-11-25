const hre = require("hardhat");

module.exports = async function verify(args) {
  await hre.run('compile');

  await hre.run("verify:verify", {
    address: args.contractAddress
  });
}