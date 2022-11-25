const { ethers } = require("hardhat");
const { expect } = require('chai');
require("solidity-coverage");

describe('BookLibrary', () => {
    let contract, factory, owner, address1, address2;

    before(async () => {
        factory = await ethers.getContractFactory('BookLibrary');
        contract = await factory.deploy();
        [owner, address1, address2, _] = await ethers.getSigners();
    })

    describe('DEPLOYMENT', () => {
        it('Should set the right owner', async () => {
            expect(await contract.owner()).to.equal(owner.address);
        });
    })

    describe('BOOK ADDITION', () => {
        it('Should only add book if owner', async () => {
            await expect(contract.connect(address1).AddUpdateBook('ISBN1', 'Lord of the Rings', 5)).to.be.revertedWith('Ownable: caller is not the owner')
        });
    });
});