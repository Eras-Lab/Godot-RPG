extends Node

var player

func use_slot_data(slot_data: SlotData) -> void:
		slot_data.item_data.use(player)

func equip_slot_data(slot_data: SlotData) -> void:
		slot_data.item_data.equip(player)

func unequip_slot_data(slot_data: SlotData) -> void:
		slot_data.item_data.unequip(player)
			
func get_global_position() -> Vector2:
	return player.global_position
