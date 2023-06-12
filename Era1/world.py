import json

class World:
    def __init__(self):
        self.characters = {}  
        self.items = {}  
        self.locations = {} 
        self.shops = {}
        self.buildings = {}
        self.monsters = {}
        

    def initialize(self, characters=None, items=None, locations=None, shops=None, buildings=None, monsters=None):
        # Adding Locations
        if locations is not None:
            for location in locations:
                self.add_location(location)

        # Adding Characters
        if characters is not None:
            for character in characters:
                self.add_character(character)

        # Adding Items
        if items is not None:
            for item in items:
                self.add_item(item)

        # Adding Shops
        if shops is not None:
            for shop in shops:
                self.add_shop(shop)

        # Adding Buildings
        if buildings is not None:
            for building in buildings:
                self.add_building(building)

        # Adding Monsters
        if monsters is not None:
            for monster in monsters:
                self.add_monster(monster)

    def add_character(self, character):
        self.characters[character.id] = character

    def add_item(self, item):
        self.items[item.name] = item

    def add_location(self, location):
        self.locations[location.id] = location

    def add_shop(self, shop):
        self.shops[shop.id] = shop

    def add_building(self, building):
        self.buildings[building.name] = building

    def add_monster(self, monster):
        self.monsters[monster.name] = monster

    def get_character(self, character_id):
        return self.characters.get(character_id)

    def get_item(self, item_id):
        return self.items.get(item_id)

    def get_location(self, location_id):
        return self.locations.get(location_id)

    def get_shop(self, shop_id):
        return self.shops.get(shop_id)

    def get_building(self, building_id):
        return self.buildings.get(building_id)

    def get_monster(self, monster_id):
        return self.monsters.get(monster_id)

    def process_action(self, action_json):
        thoughts = json.loads(action_json)["thoughts"]
        print("---------------------THOUGHTS: ", thoughts)
        action = json.loads(action_json)
        action = action["command"]
        character = self.get_character(action["character_id"])
        output = "character: " + str(character) + "\n"
        if action["action_type"] == "Pick_Up_Item":
            item = self.get_item(action["parameters"]["item_id"])
            output += character.pick_up_item(item)
        elif action["action_type"] == "Use_Item":
            item = self.get_item(action["parameters"]["item_id"])
            output += character.use_item(item)
        elif action["action_type"] == "Trade":
            shop = self.get_shop(action["parameters"]["shop_id"])
            item = self.get_item(action["parameters"]["item_id"])
            output += character.trade(shop, item)
        elif action["action_type"] == "Train":
            building = self.get_building(action["parameters"]["building_id"])
            output += character.train(building)
        elif action["action_type"] == "Battle":
            monster = self.get_monster(action["parameters"]["monster_id"])
            print(action["parameters"]["monster_id"])
            print(monster)
            output += character.battle(monster)
        elif action["action_type"] == "Converse":
            dialogue = Dialogue(action["parameters"]["dialogue_id"], action["parameters"]["text"])
            listener_id = action["parameters"]["listener_id"]
            output += character.converse(dialogue, self, listener_id) # this should be okay            
        return output
    
    def get_all_characters(self):
        return list(self.characters.values())
        
    def get_all_buildings(self):
        return list(self.buildings.values())
    
    def get_all_monsters(self):
        return list(self.monsters.values())

    def get_all_items(self):
        return list(self.items.values())    
    


class Character:
    def __init__(self, character_id, name, location_id, health=100, strength=10, agility=10, intelligence=10, charisma=10):
        self.id = character_id
        self.name = name
        self.location_id = location_id
        self.health = health
        self.strength = strength
        self.agility = agility
        self.intelligence = intelligence
        self.charisma = charisma
        self.inventory = []
        self.actions = []
        self.exp = 0  # new attribute
        self.level = 1  # new attribute

    def level_up(self):
        if self.exp >= 100:  # arbitrary condition for leveling up
            self.level += 1
            self.strength += 5  # arbitrary increase in stats
            self.agility += 5
            self.intelligence += 5
            self.charisma += 5
            self.exp -= 100  # reset exp to zero after leveling up
            print(f"{self.name} leveled up to level {self.level}!")

    def gain_exp(self, amount):
        self.exp += amount
        self.level_up()  # check if character can level up
        return f"{self.name} gained {amount} experience points!"


    def battle(self, monster):
        while self.health > 0 and monster.health > 0:
            monster.health -= self.strength
            self.health -= monster.damage
            print(f"{self.name} attacked {monster.name} and reduced its health to {monster.health}!")
            if monster.health > 0:
                print(f"{monster.name} attacked {self.name} and reduced its health to {self.health}!")

        if self.health > 0:
            print(f"{self.name} defeated the {monster.name}!")
            self.gain_exp(50)  # arbitrary amount of experience points gained
        else:
            print(f"The {monster.name} defeated {self.name}!")
        # Should output player initial health, monster initial health, player final health and earned xp.

        return "Battle finished"


    def interact(self, action_type, parameters):
        action = {
            "character_id": self.id,
            "action_type": action_type,
            "parameters": parameters
        }
        self.actions.append(action) 
        return json.dumps(action)

    def pick_up_item(self, item):
        self.inventory.append(item)
        return f"{self.name} picked up {item.name}!\n"

    def use_item(self, item):
        if item in self.inventory:
            self.inventory.remove(item)
        return f"{self.name} used {item.name}!"
 

    def trade(self, shop, item):
        if item in self.inventory:
            shop.add_item(item)
            self.inventory.remove(item)
            return f"{self.name} traded {item.name} at {shop.name}!"

    def train(self, building):
        self.strength += building.training_bonus
        return f"{self.name} trained at the {building.name} and increased their strength to {self.strength}!"
    
    def converse(self, world, dialogue, listener_id):
        print("world: ", world)
        return "Conversation"
        # listener = world.characters[listener_id]
        # dialogue.dialogue_converse(self, listener)
  

    def display_stats(self):
        return {
            'id': self.id,
            'name': self.name,
            'location_id': self.location_id,
            'health': self.health,
            'strength': self.strength,
            'agility': self.agility,
            'intelligence': self.intelligence,
            'charisma': self.charisma,
            'inventory': [item.name for item in self.inventory]
        }    
    
    def display_inventory(self):
        return [item.name for item in self.inventory]   
     
    def get_last_actions(self, N):
        return self.actions[-N:]    


class Item:
    def __init__(self, item_id, name):
        self.id = item_id
        self.name = name


class Location:
    def __init__(self, location_id, name):
        self.id = location_id
        self.name = name


class Shop:
    def __init__(self, shop_id, name):
        self.id = shop_id
        self.name = name
        self.inventory = []

    def add_item(self, item):
        self.inventory.append(item)


class Building:
    def __init__(self, building_id, name, training_bonus):
        self.id = building_id
        self.name = name
        self.training_bonus = training_bonus


class Monster:
    def __init__(self, monster_id, name, health, damage):
        self.id = monster_id
        self.name = name
        self.health = health
        self.damage = damage

class Dialogue:
    def __init__(self, dialogue_id, text):
        self.id = dialogue_id
        self.text = text

    def dialogue_converse(self, speaker, listener):
        print(f"{speaker.name} to {listener.name}: {self.text}")


# # Initialize the world
# world = World()

# # Create some locations
# town = Location(1, "Town")
# dungeon = Location(2, "Dungeon")

# # Add the locations to the world
# world.add_location(town)
# world.add_location(dungeon)

# # Create characters
# hero = Character(1, "Hero", town.id)
# villain = Character(2, "Villain", dungeon.id)
# ally1 = Character(3, "Ally1", town.id)
# ally2 = Character(4, "Ally2", town.id)

# # Add the characters to the world
# world.add_character(hero)
# world.add_character(villain)
# world.add_character(ally1)
# world.add_character(ally2)

# # Create items
# sword = Item(1, "Sword")
# potion = Item(2, "Potion")

# # Add the items to the world
# world.add_item(sword)
# world.add_item(potion)

# # Create a shop
# shop = Shop(1, "Blacksmith")

# # Add the shop to the world
# world.add_shop(shop)

# # Create a building
# gym = Building(1, "Gym", 10)

# # Add the building to the world
# world.add_building(gym)

# # Create a monster
# dragon = Monster(1, "Dragon", 200, 15)

# # Add the monster to the world
# world.add_monster(dragon)

# # The hero picks up the sword
# pick_up_sword_action = hero.interact("Pick_Up_Item", {"item_id": sword.id})
# world.process_action(pick_up_sword_action)

# # The hero picks up the potion
# pick_up_potion_action = hero.interact("Pick_Up_Item", {"item_id": potion.id})
# world.process_action(pick_up_potion_action)

# #converse
# converse_action = hero.interact("Converse", {"dialogue_id": 1, "text": "Hello Villain, prepare to be defeated!", "listener_id": villain.id})
# world.process_action(converse_action)


# # The hero trades the sword at the shop
# trade_sword_action = hero.interact("Trade", {"shop_id": shop.id, "item_id": sword.id})
# world.process_action(trade_sword_action)

# # The hero trains at the gym
# train_gym_action = hero.interact("Train", {"building_id": gym.id})
# world.process_action(train_gym_action)

# # The hero battles the dragon
# battle_dragon_action = hero.interact("Battle", {"monster_id": dragon.id})
# world.process_action(battle_dragon_action)

# battle_dragon_action = hero.interact("Battle", {"monster_id": dragon.id, "team_ids": [ally1.id, ally2.id]})
# world.process_action(battle_dragon_action)


# # The hero uses the potion
# use_potion_action = hero.interact("Use_Item", {"item_id": potion.id})
# world.process_action(use_potion_action)

# # Try to battle the dragon again
# battle_dragon_action = hero.interact("Battle", {"monster_id": dragon.id})
# world.process_action(battle_dragon_action)

# hero_stats = hero.display_stats()
# print(hero_stats)

# hero_inventory = hero.display_inventory()
# print(hero_inventory)

# last_actions = hero.get_last_actions(2)
# print(last_actions)

# characters = world.get_all_characters()
# buildings = world.get_all_buildings()

# # Print their details
# for character in characters:
#     print(character.display_stats())
# for building in buildings:
#     print(f"Building ID: {building.id}, Name: {building.name}, Training Bonus: {building.training_bonus}")