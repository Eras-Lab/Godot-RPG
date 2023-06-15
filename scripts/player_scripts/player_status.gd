extends Node

class_name player_status

#Make this initialization programable
var player_name = "Garrick Stormwind"

#player stats
var max_health = 300
var health = 300
var attack_damage = 10
var defense = 10
var stamina = 10
var strength = 10
var constitution = 10
var dexterity = 10
var intelligence = 10

func heal(heal_value: int) -> void:
	health += heal_value
	update_attribute_on_chain("health", health)

func equip(stats) -> void:
	if stats["attack_damage"]:
		attack_damage += stats["attack_damage"]
		update_attribute_on_chain("attack", attack_damage)
	
	if stats["strength"]:
		strength += stats["strength"]
		update_attribute_on_chain("strength", strength)
	
	if stats["constitution"]:
		constitution += stats["constitution"]
		update_attribute_on_chain("constitution", constitution)

func unequip(stats) -> void:
	if stats["attack_damage"]:
		attack_damage -= stats["attack_damage"]
		update_attribute_on_chain("attack", attack_damage)
	
	if stats["strength"]:
		strength -= stats["strength"]
		update_attribute_on_chain("strength", strength)
	
	if stats["constitution"]:
		constitution -= stats["constitution"]
		update_attribute_on_chain("constitution", constitution)

func increase_attack_damage(amount):
	attack_damage += amount
	update_attribute_on_chain("attack", attack_damage)

func increase_strength(amount):
	strength += amount
	update_attribute_on_chain("strength", strength)	

func increase_health(amount):
	health += amount
	update_attribute_on_chain("health", health)

func increase_constitution(amount):
	constitution += amount
	update_attribute_on_chain("constitution", constitution)

func update_attribute_on_chain(attribute, value):
	# This function implementation depends on your implementation
	# TODO
	pass
	

