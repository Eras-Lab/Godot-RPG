extends ItemData
class_name ItemDataEquip

enum Type { HEAD, CHEST, LEGS, FEET, MAINHAND, OFFHAND, TWOHAND }
@export var type: Type
@export var attack_damage: int
@export var strength: int
@export var constitution: int

func equip(target) -> void:
	target.player_status.equip({"attack_damage": attack_damage, "strength": strength, "constitution": constitution})

func unequip(target) -> void:
	target.player_status.unequip({"attack_damage": attack_damage, "strength": strength, "constitution": constitution})
