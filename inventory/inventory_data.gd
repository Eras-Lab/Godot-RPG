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
