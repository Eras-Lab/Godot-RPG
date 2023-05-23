import { mudConfig } from "@latticexyz/world/register";

// Attributes: health, attack, defense, stamina, strength, constitution, dexterity, intelligence

export default mudConfig({
  tables: {
    HealthComponent: "uint256",
    AttackComponent: "uint256",
    DefenseComponent: "uint256",
    StaminaComponent: "uint256",
    StrengthComponent: "uint256",
    ConstitutionComponent: "uint256",
    DexterityComponent: "uint256",
    IntelligenceComponent: "uint256",
  },
});

// export default mudConfig({
//     tables: {
//         PlanetComponent: {
//             keySchema: {},
//             schema: {
//                 theme: "string",
//             },
//         },
//         NameComponent: "string",
//         DescriptionComponent: "string",
//         PriceComponent: "uint256",
//         RaceComponent: "string",
//         CharacterComponent: "bytes32",
//         TangibleComponent: "bool",
//         CountComponent: "uint256",
//         LocationComponent: {
//             schema: {
//                 at: "string",
//             },
//         },
//     },
//     modules: [
//         {
//             name: "UniqueEntityModule",
//             root: true,
//             args: [],
//         },
//     ],
// });
