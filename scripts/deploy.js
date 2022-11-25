const hre = require("hardhat");
const fs = require('fs');

module.exports = async function deployContract(args) {
  await hre.run('compile');
  const wallet = new ethers.Wallet(args.privateKey, hre.ethers.provider);
  
  console.log('Deploying contracts with the account:', wallet.address);
  console.log('Account balance:', (await wallet.getBalance()).toString());
  const contractFactory = await hre.ethers.getContractFactory("BookLibrary", wallet);
  const contract = await contractFactory.deploy();

  await contract.deployed();
  console.log("Deployed to:", contract.address);

  // Provide the contract data to the frontend app
  const data = {
    address: contract.address,
    abi: JSON.parse(contract.interface.format('json'))
  }
  fs.writeFileSync('client/src/contracts/BookLibrary.json', JSON.stringify(data));
}