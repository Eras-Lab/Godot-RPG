extends Node

class_name player_status

#New setup with Characters as globally accessible Dictionaries.
var character1 = {
	"name": "Garrick Stormwind",
	"max_health": 300,
	"health": 300,
	"attack_damage": 10,
	"defense": 10,
	"stamina": 10,
	"strength": 10,
	"constitution": 10,
	"dexterity": 10,
	"intelligence": 10,
	"experience": 10,
	"gold": 10,
	"kills": 0,
	"inventory": preload("res://inventory/character_inventories/garrick_inv.tres"),
	"equipped_items": preload("res://inventory/character_inventories/garrick_inv_equip.tres")
}

var character2 = {
	"name": "Freya Swiftwind",
	"max_health": 250,
	"health": 250,
	"attack_damage": 10,
	"defense": 10,
	"stamina": 20,
	"strength": 30,
	"constitution": 10,
	"dexterity": 50,
	"intelligence": 10,
	"experience": 10,
	"gold": 25,
	"kills": 0,
	"inventory": preload("res://inventory/character_inventories/freya_inv.tres"),
	"equipped_items": preload("res://inventory/character_inventories/freya_inv_equip.tres")
}

var characters = {
	1: character1,
	2: character2
}

func get_character(num):
	return characters[num]

func get_characters():
	return characters
	
#Old player stats, still used for Combat with monsters. 
#Needs to be removed after Combat is updated to use the dictionaries
var max_health = 300
var health = 300
var attack_damage = 10
var defense = 10
var stamina = 10
var strength = 10
var constitution = 10
var dexterity = 10
var intelligence = 10

var experience = 0
var gold = 100

func heal(heal_value: int, characterNum: int) -> void:
	characters[characterNum].health += heal_value
	update_attribute_on_chain("health", characters[characterNum].health)
	
	Overlay.update_stats(characterNum)
	
func equip(stats, characterNum: int) -> void:
	if stats["attack_damage"]:
		characters[characterNum].attack_damage += stats["attack_damage"]
		update_attribute_on_chain("attack", characters[characterNum].attack_damage)
	
	if stats["strength"]:
		characters[characterNum].strength += stats["strength"]
		update_attribute_on_chain("strength", characters[characterNum].strength)
	
	if stats["constitution"]:
		characters[characterNum].constitution += stats["constitution"]
		update_attribute_on_chain("constitution", characters[characterNum].constitution)
	
	Overlay.update_stats(characterNum)
	
func unequip(stats, characterNum: int) -> void:
	if stats["attack_damage"]:
		characters[characterNum].attack_damage -= stats["attack_damage"]
		update_attribute_on_chain("attack", characters[characterNum].attack_damage)
	
	if stats["strength"]:
		characters[characterNum].strength -= stats["strength"]
		update_attribute_on_chain("strength", characters[characterNum].strength)
	
	if stats["constitution"]:
		characters[characterNum].constitution -= stats["constitution"]
		update_attribute_on_chain("constitution", characters[characterNum].constitution)
	
	Overlay.update_stats(characterNum)
	
func increase_attack_damage(amount, characterNum):
	characters[characterNum].attack_damage += amount
	update_attribute_on_chain("attack", characters[characterNum].attack_damage)
	
func increase_strength(amount, characterNum: int):
	characters[characterNum].strength += amount
	update_attribute_on_chain("strength", characters[characterNum].strength)	

func increase_health(amount, characterNum: int):
	characters[characterNum].health += amount
	update_attribute_on_chain("health", characters[characterNum].health)

func increase_constitution(amount, characterNum: int):
	characters[characterNum].constitution += amount
	update_attribute_on_chain("constitution", characters[characterNum].constitution)

func update_attribute_on_chain(attribute, value):
	# This function implementation depends on your implementation
	# TODO
	pass
	

