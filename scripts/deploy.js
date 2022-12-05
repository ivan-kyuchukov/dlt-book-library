const hre = require("hardhat");
const ethers = hre.ethers;
const fs = require('fs');

async function deployContract() {
    await hre.run('compile');
    const [deployer] = await ethers.getSigners();
  
    console.log('Deploying contracts with the account:', deployer.address);
    console.log('Account balance:', (await deployer.getBalance()).toString());

    const contractFactory = await ethers.getContractFactory("BookLibrary"); // 
    const contract = await contractFactory.deploy();
    console.log('Waiting for BookLibrary deployment...');
    await contract.deployed();

    console.log('BookLibrary Contract address: ', contract.address);
    console.log('Done!');

    // Provide the contract data to the frontend app
    const data = {
      address: contract.address,
      abi: JSON.parse(contract.interface.format('json'))
    }
    fs.writeFileSync('client/src/contracts/BookLibrary.json', JSON.stringify(data));
}
  
module.exports = deployContract;