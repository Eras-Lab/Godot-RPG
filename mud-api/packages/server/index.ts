import * as dotenv from "dotenv";
import cors from "cors";
import express, { Request, Response, NextFunction } from "express";
import { CharacterStats, CharacterStory } from "types";
import { setup } from "./lib/mud/setup";
import { useComponentValue } from "@latticexyz/react";

dotenv.config();
const app = express();
const port = 3000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(
  cors({
    origin: "*",
  })
);

app.get("/", (req: Request, res: Response) => {
  res.send("Hello, world!");
});

app.get(
  "/attribute/:attribute/:player",
  async (req: Request, res: Response) => {
    try {
      const mud = await setup();
      const network = mud.network;
      const components = mud.components;
      const systemCalls = mud.systemCalls;

      const { player, attribute } = req.params;
      console.log("============ Attribute: ", attribute);
      switch (attribute) {
        case "health":
          const health = await systemCalls.getHealth(player);
          console.log("Health: ", health);
          sendResponse(res, { result: health });
          break;
        case "attack":
          const attack = await systemCalls.getAttack(player);
          console.log("Attack: ", attack);
          sendResponse(res, { result: attack });
          break;
        case "defense":
          const defense = await systemCalls.getDefense(player);
          console.log("Defense: ", defense);
          sendResponse(res, { result: defense });
          break;
        case "stamina":
          const stamina = await systemCalls.getStamina(player);
          console.log("Stamina: ", stamina);
          sendResponse(res, { result: stamina });
          break;
        case "strength":
          const strength = await systemCalls.getStrength(player);
          console.log("Strength: ", strength);
          sendResponse(res, { result: strength });
          break;
        case "constitution":
          const constitution = await systemCalls.getConstitution(player);
          console.log("Constitution: ", constitution);
          sendResponse(res, { result: constitution });
          break;
        case "dexterity":
          const dexterity = await systemCalls.getDexterity(player);
          console.log("Dexterity: ", dexterity);
          sendResponse(res, { result: dexterity });
          break;
        case "intelligence":
          const intelligence = await systemCalls.getIntelligence(player);
          console.log("Intelligence: ", intelligence);
          sendResponse(res, { result: intelligence });
          break;
        default:
          console.log("Attribute not found");
          sendResponse(res, { result: "Attribute not found" });
      }
    } catch (e) {
      console.log("Error: ", e);
      sendResponse(res, { result: e });
    }
  }
);

app.post("/attribute", async (req: Request, res: Response) => {
  try {
    const mud = await setup();
    const network = mud.network;
    const components = mud.components;
    const systemCalls = mud.systemCalls;

    const { player, attribute, value } = req.body;

    /*
  Attributes: health, attack, defense, stamina, strength, constitution, dexterity, intelligence 
  */
    console.log("============ Attribute: ", attribute);
    switch (attribute) {
      case "health":
        await systemCalls.setHealth(player, value);
        console.log(
          "Attribute " +
            attribute +
            " set to " +
            value +
            " for player " +
            player
        );
        sendResponse(res, { result: "Health set" });
        break;
      case "attack":
        await systemCalls.setAttack(player, value);
        console.log(
          "Attribute " +
            attribute +
            " set to " +
            value +
            " for player " +
            player
        );
        res.send("Attack set");
        break;
      case "defense":
        await systemCalls.setDefense(player, value);
        console.log(
          "Attribute " +
            attribute +
            " set to " +
            value +
            " for player " +
            player
        );
        sendResponse(res, { result: "Defense set" });
        break;
      case "stamina":
        await systemCalls.setStamina(player, value);
        console.log(
          "Attribute " +
            attribute +
            " set to " +
            value +
            " for player " +
            player
        );
        sendResponse(res, { result: "Stamina set" });
        break;
      case "strength":
        await systemCalls.setStrength(player, value);
        console.log(
          "Attribute " +
            attribute +
            " set to " +
            value +
            " for player " +
            player
        );
        sendResponse(res, { result: "Strength set" });
        break;
      case "constitution":
        await systemCalls.setConstitution(player, value);
        console.log(
          "Attribute " +
            attribute +
            " set to " +
            value +
            " for player " +
            player
        );
        sendResponse(res, { result: "Constitution set" });
        break;
      case "dexterity":
        await systemCalls.setDexterity(player, value);
        console.log(
          "Attribute " +
            attribute +
            " set to " +
            value +
            " for player " +
            player
        );
        sendResponse(res, { result: "Dexterity set" });
        break;
      case "intelligence":
        await systemCalls.setIntelligence(player, value);
        console.log(
          "Attribute " +
            attribute +
            " set to " +
            value +
            " for player " +
            player
        );
        sendResponse(res, { result: "Intelligence set" });
        break;

      default:
        console.log("No attribute set");
        sendResponse(res, { result: "No attribute set" });
        break;
    }
  } catch (error) {
    console.error("Error in attribute route:", error);
    res.status(500).send("Internal Server Error");
  }
});

// Error handling middleware
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  console.error(err.stack);
  res.status(500).send("Internal Server Error");
});

app.listen(port, () => {
  console.log(`Listening on port ${port}`);
});

// Utility function to send JSON response
function sendResponse(res: Response, data: any) {
  try {
    res.setHeader("Content-Type", "application/json");
    res.send(JSON.stringify(data));
  } catch (err) {
    console.error("Error sending response:", err);
    // Handle write EPIPE error and close the response stream gracefully
    if (!res.headersSent && !res.finished) {
      res.end();
    }
  }
}
