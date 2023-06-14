extends Node

#inventory manager of everything

var players = []
var buildings = []
var player

func set_player(_player):
	player = _player

func use_slot_data(slot_data: SlotData) -> void:
	print(player)
	slot_data.item_data.use(player)

func equip_slot_data(slot_data: SlotData) -> bool:
	var able_to_equip = player.equip_inventory_data.equip_item(slot_data)
	slot_data.item_data.equip(player)
	return able_to_equip


func sell_slot_data(slot_data: SlotData):
	pass

func unequip_slot_data(slot_data: SlotData) -> void:
	player.inventory_data.store_item(slot_data)
	print("player manager unequip", slot_data.item_data)
	slot_data.item_data.unequip(player)

func craft_item(recipeslot1: SlotData, slot2: SlotData):
	pass

func trade(inventory_data, inv2):
	pass

func get_inventory_data(playerId: int):
	return player.inventory_data
