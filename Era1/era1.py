from autonomous_npc import AutonomousNPC
from world import World, Character, Item, Location, Shop, Building, Monster
import os
import json
import threading
import random

# Define a function to read a template from a text file
def read_template_from_file(filename):
    with open(filename, 'r') as file:
        return file.read()

api_key = "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"
os.environ["OPENAI_API_KEY"] = api_key

# Read the template from the file
system_template = read_template_from_file('system_prompt_template2.txt')

templates = [
    {
        "system_template": system_template,
        "human_template": "{text}"
    }
]

# Initialize AutonomousNPC and World
autonomous_npc = AutonomousNPC(model_name="gpt-3.5-turbo", temperature=0, api_key=api_key, templates=templates)
world = World()
# Create some locations
locations = [
    Location(1, "Town"),
    Location(2, "Dungeon"),
    Location(3, "Forest"),
    Location(4, "Mountain"),
    Location(5, "Cave")
]


hero = Character(1, "Hero", locations[0].id)
villain = Character(2, "Villain", locations[1].id)
ally1 = Character(3, "Ally1", locations[0].id)
ally2 = Character(4, "Ally2", locations[0].id)
enemy = Character(5, "Enemy", locations[1].id)

# Create characters
characters = [
    hero,
    villain,
    ally1,
    ally2,
    enemy
]

# Create items
items = [
    Item(1, "Sword"),
    Item(2, "Shield"),
    Item(3, "Potion"),
    Item(4, "Bow"),
    Item(5, "Armor")
]

# Create shops
shops = [
    Shop(1, "Blacksmith"),
    Shop(2, "General Store"),
    Shop(3, "Magic Shop"),
    Shop(4, "Potion Shop"),
    Shop(5, "Weapon Shop")
]

# Create buildings
buildings = [
    Building(1, "Gym", 10),
    Building(2, "Tavern", 5),
    Building(3, "Library", 3),
    Building(4, "Castle", 15),
    Building(5, "Temple", 8)
]

# Create monsters
monsters = [
    Monster(1, "Dragon", 200, 15),
    Monster(2, "Goblin", 50, 5),
    Monster(3, "Skeleton", 80, 8),
    Monster(4, "Orc", 100, 10),
    Monster(5, "Slime", 30, 3)
]


# Initialize the world using the initialize function
world.initialize(
    characters=characters,
    items=items,
    locations=locations,
    shops=shops,
    buildings=buildings,
    monsters=monsters
)

last_actions = []

def spawn_item():
    item_names = ["Sword", "Shield", "Potion", "Bow", "Armor"]
    item_id = len(world.items) + 1
    item_name = random.choice(item_names)
    new_item = Item(item_id, item_name)
    world.items.append(new_item)
    print(f"New item {item_name} spawned with id {item_id}")

def spawn_monster():
    monster_names = ["Dragon", "Goblin", "Skeleton", "Orc", "Slime"]
    monster_id = len(world.monsters) + 1
    monster_name = random.choice(monster_names)
    hp = random.randint(30, 200)
    damage = random.randint(3, 15)
    new_monster = Monster(monster_id, monster_name, hp, damage)
    world.monsters.append(new_monster)
    print(f"New monster {monster_name} spawned with id {monster_id}, HP {hp} and damage {damage}")


def process_round(observations):
    input_params = {"text": observations}
    
    print("inputs: ", input_params)
    responses = autonomous_npc.run(input_params)

    print("responses: ", responses)
    response_json = responses[0]
    
    print("World characters: ", world.get_all_characters())
    last_action_outcome = world.process_action(response_json)

    last_actions.append({"action": response_json, "outcome": last_action_outcome})
    print("-------------------------")
    print("Last actions: ", last_actions)
    print("-------------------------")


def game_loop(character):
    last_action = ""
    last_action_outcome = ""

    while True:
        # Generate observations based on current state of the World
        location = world.locations[character.location_id].name
        inventory = ', '.join(str(item) for item in character.inventory)
        character_name = character.name
        character_id = character.id

        # - Result of the last action
        if last_actions:
            last_action_outcome = last_actions[-1]["outcome"]
            last_action = last_actions[-1]["action"]
            # Save the last actions to a txt file
            filename = f"./frontend-flask/last_actions_{character_name}.txt"
            with open(filename, 'a') as file:
                file.write(json.dumps(last_actions[-1]) + '\n')

        # - Character's stats
        stats = character.display_stats()

        # - List of Characters
        characters = ', '.join([char.name for char in world.get_all_characters()])

        # - List of Items
        items = ', '.join([item.name for item in world.get_all_items()])

        # - List of Buildings
        buildings = ', '.join([building.name for building in world.get_all_buildings()])

        # Generate the observation string
        observations = (
            f"{character_name} (id: {character_id}) is currently in {location} and has items {inventory}. "
            f"{character_name}'s stats are {stats}. "
            f"The characters in the world are {characters}. "
            f"The items in the world are {items}. "
            f"The buildings in the world are {buildings}. "
            f"The last action performed was {last_action} with outcome {last_action_outcome}. "
            f"You are currently in town, but you need to get stronger, kill monsters, earn level and xp, and buy items."
            F"Be very careful as if you die you cannot be revived and all your items will be lost."
        )
        
        process_round(observations)


print("Starting World")

# create threads
hero_thread = threading.Thread(target=game_loop, args=(hero,))
ally1_thread = threading.Thread(target=game_loop, args=(ally1,))
ally2_thread = threading.Thread(target=game_loop, args=(ally2,))
print("Starting Threads")

# start threads
hero_thread.start()
ally1_thread.start()
ally2_thread.start()

# join threads to the main thread
hero_thread.join()
ally1_thread.join()
ally2_thread.join()


