// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { System } from "@latticexyz/world/src/System.sol";
import { getUniqueEntity } from "@latticexyz/world/src/modules/uniqueentity/getUniqueEntity.sol";
import { stringToEntityKey } from "../stringToEntityKey.sol";

import {
  HealthComponent,
    AttackComponent,
    DefenseComponent,
    StaminaComponent,
    StrengthComponent,
    ConstitutionComponent,
    DexterityComponent,
    IntelligenceComponent
    
} from "../codegen/Tables.sol";

import { Constants } from "../lib/Constants.sol";

// Attributes: health, attack, defense, stamina, strength, constitution, dexterity, intelligence

contract AttributeSystem is System {
  function setHealth(
    string memory entityID,
    uint256 health
  )
  public
  {
    bytes32 entityKey = stringToEntityKey(entityID);
    HealthComponent.set(entityKey, health);
  }

    function getHealth(
        string memory entityID
    )
        public
        view
        returns (uint256)
    {
        bytes32 entityKey = stringToEntityKey(entityID);
        return HealthComponent.get(entityKey);
    }

    function setAttack(
        string memory entityID,
        uint256 attack
    )
        public
    {
        bytes32 entityKey = stringToEntityKey(entityID);
        AttackComponent.set(entityKey, attack);
    }

    function getAttack(
        string memory entityID
    )
        public
        view
        returns (uint256)
    {
        bytes32 entityKey = stringToEntityKey(entityID);
        return AttackComponent.get(entityKey);
    }

    function setDefense(
        string memory entityID,
        uint256 defense
    )
        public
    {
        bytes32 entityKey = stringToEntityKey(entityID);
        DefenseComponent.set(entityKey, defense);
    }

    function getDefense(
        string memory entityID
    )
        public
        view
        returns (uint256)
    {
        bytes32 entityKey = stringToEntityKey(entityID);
        return DefenseComponent.get(entityKey);
    }

    function setStamina(
        string memory entityID,
        uint256 stamina
    )
        public
    {
        bytes32 entityKey = stringToEntityKey(entityID);
        StaminaComponent.set(entityKey, stamina);
    }

    function getStamina(
        string memory entityID
    )
        public
        view
        returns (uint256)
    {
        bytes32 entityKey = stringToEntityKey(entityID);
        return StaminaComponent.get(entityKey);
    }

    function setStrength(
        string memory entityID,
        uint256 strength
    )
        public
    {
        bytes32 entityKey = stringToEntityKey(entityID);
        StrengthComponent.set(entityKey, strength);
    }

    function getStrength(
        string memory entityID
    )
        public
        view
        returns (uint256)
    {
        bytes32 entityKey = stringToEntityKey(entityID);
        return StrengthComponent.get(entityKey);
    }

    function setConstitution(
        string memory entityID,
        uint256 constitution
    )
        public
    {
        bytes32 entityKey = stringToEntityKey(entityID);
        ConstitutionComponent.set(entityKey, constitution);
    }

    function getConstitution(
        string memory entityID
    )
        public
        view
        returns (uint256)
    {
        bytes32 entityKey = stringToEntityKey(entityID);
        return ConstitutionComponent.get(entityKey);
    }

    function setDexterity(
        string memory entityID,
        uint256 dexterity
    )
        public
    {
        bytes32 entityKey = stringToEntityKey(entityID);
        DexterityComponent.set(entityKey, dexterity);
    }

    function getDexterity(
        string memory entityID
    )
        public
        view
        returns (uint256)
    {
        bytes32 entityKey = stringToEntityKey(entityID);
        return DexterityComponent.get(entityKey);
    }

    function setIntelligence(
        string memory entityID,
        uint256 intelligence
    )
        public
    {
        bytes32 entityKey = stringToEntityKey(entityID);
        IntelligenceComponent.set(entityKey, intelligence);
    }

    function getIntelligence(
        string memory entityID
    )
        public
        view
        returns (uint256)
    {
        bytes32 entityKey = stringToEntityKey(entityID);
        return IntelligenceComponent.get(entityKey);
    }

}
