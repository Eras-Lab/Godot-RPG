extends ItemData
class_name  ItemDataConsumable

@export var heal_value: int

func use(target) -> void:
	if heal_value != 0:
		target.player_status.heal(heal_value)
