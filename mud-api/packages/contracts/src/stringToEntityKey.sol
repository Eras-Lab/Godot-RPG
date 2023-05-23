// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

function stringToEntityKey(string memory str) pure returns (bytes32) {
  return bytes32(keccak256(bytes(str)));
}