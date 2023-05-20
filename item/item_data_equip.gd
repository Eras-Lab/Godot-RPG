extends ItemData
class_name ItemDataEquip

@export var attack_damage: int
@export var strength: int
@export var constitution: int

func equip(target) -> void:
	target.equip({"attack_damage": attack_damage, "strength": strength, "constitution": constitution})

func unequip(target) -> void:
	target.unequip({"attack_damage": attack_damage, "strength": strength, "constitution": constitution})
