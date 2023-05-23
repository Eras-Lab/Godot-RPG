import { SetupNetworkResult } from "./setupNetwork";
import {
  CharacterStatsComponentDataStruct,
  CharacterStoryComponentDataStruct,
} from "contracts/types/ethers-contracts/IWorld";

export type SystemCalls = ReturnType<typeof createSystemCalls>;

export function createSystemCalls({
  worldSend,
  txReduced$,
  singletonEntity,
}: SetupNetworkResult) {
  // const createPlayerCharacter = async (story: CharacterStoryComponentDataStruct, stats: CharacterStatsComponentDataStruct) => {
  //     await worldSend("createPlayerCharacter", [story, stats])
  // }
  // return {
  //     createPlayerCharacter,
  // };
}
