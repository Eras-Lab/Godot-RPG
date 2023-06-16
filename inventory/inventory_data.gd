extends Resource
class_name InventoryData

signal inventory_updated(inventory_data: InventoryData)
signal inventory_interact(inventory_data: InventoryData, index: int, button: int)
signal item_equipped(inventory_data: InventoryData, index: int)

@export var slot_datas: Array[SlotData]
@export var player: int

func drop_single_slot_data(grabbed_slot_data: SlotData, index: int):
	var slot_data = slot_datas[index]
	
	if not slot_data:
		slot_datas[index] = grabbed_slot_data.create_single_slot_data()
	elif slot_data.can_merge_with(grabbed_slot_data):
		slot_data.fully_merge_with(grabbed_slot_data.create_single_slot_data())
		
	inventory_updated.emit(self)
	
	if grabbed_slot_data.quantity > 0:
		return grabbed_slot_data
	else:
		return null
		
func use_slot_data(index: int) -> void:
	var slot_data = slot_datas[index]
	
	if not slot_data:
		return
	
	if slot_data.item_data is ItemDataConsumable:
		slot_data.quantity -= 1
		if slot_data.quantity < 1:
			slot_datas[index] = null
		
	PlayerManager.use_slot_data(slot_data)
	
	inventory_updated.emit(self)

func drop_slot_data(index: int):
	var slot_data = slot_datas[index]
	
func find_empty_slot():
	for slot_data in slot_datas:
		if not slot_data.item_data:
			var empty_slot = slot_datas.find(slot_data)
			return empty_slot

func equip_slot_data(index: int):
	var slot_data = slot_datas[index].duplicate()
	
	if slot_data.item_data is ItemDataEquip:
		var able_to_equip = PlayerManager.equip_slot_data(slot_data)
		if able_to_equip:
			slot_datas[index].item_data = null
			inventory_updated.emit(self)

func store_item(slot_data: SlotData):
	var empty_slot = find_empty_slot()
	if empty_slot >= 0:
		slot_datas[empty_slot] = slot_data
		inventory_updated.emit(self)
	else:
		print("Inventory Full")

func pick_up_slot_data(slot_data) -> bool:
	
	for index in slot_datas.size():
		if slot_datas[index] and slot_datas[index].can_fully_merge_with(slot_data):
			slot_datas[index].fully_merge_with(slot_data)
			inventory_updated.emit(self)
			return true
			
	for index in slot_datas.size():
		if not slot_datas[index]:
			slot_datas[index] = slot_data
			inventory_updated.emit(self)
			return true
	
	return false

# MARKET: methods added for market

## Receives SlotData and stores it in inventory, taking into consideration
## the quantity, and handling stacking	
func add_slot_data(slot_data: SlotData) -> bool:
	for this_slot_data in slot_datas:
		if this_slot_data.item_data and this_slot_data.item_data.name == slot_data.item_data.name \
		and this_slot_data.can_fully_merge_with(slot_data):
			this_slot_data.quantity += slot_data.quantity
			inventory_updated.emit(self)
			return true
	var empty_slot = find_empty_slot()
	if empty_slot >= 0:
		slot_datas[empty_slot] = slot_data
		inventory_updated.emit(self)
		return true
	else:
		print("Inventory Full")
		return false
		
## Removes items from inventory based on the item name and quantity to remove.
## Returns SlotData containing the item and the requested quantity.
## Throws an error if the quantity of the item isn't present.
func remove_slot_data(item_name: String, quantity: int) -> SlotData:
	var removed_slot_data = null
	var slot_index = get_slot_index_from_name(item_name)
	if slot_index != -1 and slot_datas[slot_index].quantity >= quantity:
		removed_slot_data = slot_datas[slot_index].duplicate()  # create a copy of the SlotData
		removed_slot_data.quantity = quantity  # set the quantity to remove
		slot_datas[slot_index].quantity -= quantity  # subtract quantity
		if slot_datas[slot_index].quantity <= 0:  # if no more items, set item_data to null
			slot_datas[slot_index].item_data = null
		inventory_updated.emit(self)
	else:
		print("Error: quantity too low or item not found.")
	return removed_slot_data

## Helper that finds the first index holding item_data with the given name.
## Returns -1 if not found.		
func get_slot_index_from_name(item_name: String) -> int:
	var slot_index = -1
	for i in range(slot_datas.size()):
		if slot_datas[i].item_data and slot_datas[i].item_data.name == item_name:
			slot_index = i
			break
	return slot_index
	
## Helper that returns the first slot_data holding item_data with the given name.
## Throws an error if not found.
func get_slot_data_from_name(item_name: String) -> SlotData:
	var slot_index = get_slot_index_from_name(item_name)
	return slot_datas[slot_index]
	
## Creates SlotData that looks like existing items using an item name.
## Creates a new one if item with same name isn't found.
func create_slot_data(item_name: String, quantity: int) -> SlotData:
	var slot_index = get_slot_index_from_name(item_name)
	if slot_index == -1:
		var new_slot_data = SlotData.new()
		new_slot_data.item_data = ItemData.new()
		new_slot_data.item_data.name = item_name
		new_slot_data.quantity = quantity
		return new_slot_data
	else:
		var new_slot_data = slot_datas[slot_index].duplicate()
		new_slot_data.quantity = quantity
		return new_slot_data
	
# END MARKET
