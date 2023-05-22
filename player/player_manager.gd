extends Node

var player
var players = []

func use_slot_data(slot_data: SlotData, _player) -> void:
		slot_data.item_data.use(players[_player -1])

func equip_slot_data(slot_data: SlotData, _player) -> void:
	print(_player)
	slot_data.item_data.equip(players[_player -1])

func unequip_slot_data(slot_data: SlotData, _player) -> void:
		slot_data.item_data.unequip(players[_player -1])
			
func get_global_position() -> Vector2:
	return player.global_position
