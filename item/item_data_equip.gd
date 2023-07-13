extends ItemData
class_name ItemDataEquip

enum Type { HEAD, CHEST, LEGS, FEET, MAINHAND, OFFHAND, TWOHAND }
@export var type: Type
@export var attack_damage: int
@export var strength: int
@export var constitution: int

func equip(characterNum: int) -> void:
	PlayerStatus.equip({"attack_damage": attack_damage, "strength": strength, "constitution": constitution}, characterNum)

func unequip(characterNum: int) -> void:
	PlayerStatus.unequip({"attack_damage": attack_damage, "strength": strength, "constitution": constitution}, characterNum)
