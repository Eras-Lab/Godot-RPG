export function createSystemCalls(
  { worldSend }: SetupNetworkResult,
  {}: ClientComponents
): {
  setHealth: (player: string, health: number) => Promise<void>;
  getHealth: (player: string) => Promise<number>;
  setAttack: (player: string, attack: number) => Promise<void>;
  getAttack: (player: string) => Promise<number>;
  setDefense: (player: string, defense: number) => Promise<void>;
  getDefense: (player: string) => Promise<number>;
  setStamina: (player: string, stamina: number) => Promise<void>;
  getStamina: (player: string) => Promise<number>;
  setStrength: (player: string, strength: number) => Promise<void>;
  getStrength: (player: string) => Promise<number>;
  setConstitution: (player: string, constitution: number) => Promise<void>;
  getConstitution: (player: string) => Promise<number>;
  setDexterity: (player: string, dexterity: number) => Promise<void>;
  getDexterity: (player: string) => Promise<number>;
  setIntelligence: (player: string, intelligence: number) => Promise<void>;
  getIntelligence: (player: string) => Promise<number>;
} {
  const setHealth = async (player: string, health: number) => {
    await worldSend("setHealth", [player, health]);
  };

  const getHealth = async (player: string) => {
    const result = await worldSend("getHealth", [player]);
    return Number(result);
  };

  const setAttack = async (player: string, attack: number) => {
    await worldSend("setAttack", [player, attack]);
  };

  const getAttack = async (player: string) => {
    const result = await worldSend("getAttack", [player]);
    return Number(result);
  };

  const setDefense = async (player: string, defense: number) => {
    await worldSend("setDefense", [player, defense]);
  };

  const getDefense = async (player: string) => {
    const result = await worldSend("getDefense", [player]);
    return Number(result);
  };

  const setStamina = async (player: string, stamina: number) => {
    await worldSend("setStamina", [player, stamina]);
  };

  const getStamina = async (player: string) => {
    const result = await worldSend("getStamina", [player]);
    return Number(result);
  };

  const setStrength = async (player: string, strength: number) => {
    await worldSend("setStrength", [player, strength]);
  };

  const getStrength = async (player: string) => {
    const result = await worldSend("getStrength", [player]);
    return Number(result);
  };

  const setConstitution = async (player: string, constitution: number) => {
    await worldSend("setConstitution", [player, constitution]);
  };

  const getConstitution = async (player: string) => {
    const result = await worldSend("getConstitution", [player]);
    return Number(result);
  };

  const setDexterity = async (player: string, dexterity: number) => {
    await worldSend("setDexterity", [player, dexterity]);
  };

  const getDexterity = async (player: string) => {
    const result = await worldSend("getDexterity", [player]);
    return Number(result);
  };

  const setIntelligence = async (player: string, intelligence: number) => {
    await worldSend("setIntelligence", [player, intelligence]);
  };

  const getIntelligence = async (player: string) => {
    const result = await worldSend("getIntelligence", [player]);
    return Number(result);
  };

  return {
    setHealth,
    getHealth,
    setAttack,
    getAttack,
    setDefense,
    getDefense,
    setStamina,
    getStamina,
    setStrength,
    getStrength,
    setConstitution,
    getConstitution,
    setDexterity,
    getDexterity,
    setIntelligence,
    getIntelligence,
  };
}
