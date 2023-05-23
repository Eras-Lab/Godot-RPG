// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/* Autogenerated file. Do not edit manually. */

interface IAttributeSystem {
  function setHealth(string memory entityID, uint256 health) external;

  function getHealth(string memory entityID) external view returns (uint256);

  function setAttack(string memory entityID, uint256 attack) external;

  function getAttack(string memory entityID) external view returns (uint256);

  function setDefense(string memory entityID, uint256 defense) external;

  function getDefense(string memory entityID) external view returns (uint256);

  function setStamina(string memory entityID, uint256 stamina) external;

  function getStamina(string memory entityID) external view returns (uint256);

  function setStrength(string memory entityID, uint256 strength) external;

  function getStrength(string memory entityID) external view returns (uint256);

  function setConstitution(string memory entityID, uint256 constitution) external;

  function getConstitution(string memory entityID) external view returns (uint256);

  function setDexterity(string memory entityID, uint256 dexterity) external;

  function getDexterity(string memory entityID) external view returns (uint256);

  function setIntelligence(string memory entityID, uint256 intelligence) external;

  function getIntelligence(string memory entityID) external view returns (uint256);
}
