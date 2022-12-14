//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ownable {
  address private _owner;

  constructor() {
    _owner = msg.sender;
  }

  function owner() public view virtual returns (address) {
    return _owner;
  }

  modifier onlyOwner() {
    require(msg.sender == owner(), "Caller is not the owner.");
    _;
  }

  modifier onlyNotOwner() {
    require(msg.sender != owner(), "Caller is the owner.");
    _;
  }
}