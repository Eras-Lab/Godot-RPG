extends InventoryData
class_name InventoryDataEquip

func equip_item(slot_data):
	var type = slot_data.item_data.type
	var type_already_equipped = false
	var able_to_equip = false
	
	for item in slot_datas:
		if item.item_data and item.item_data.type == type:
			print("item of this type already equipped")
			type_already_equipped = true

	if not type_already_equipped:
		var empty_slot = find_empty_slot()
		if empty_slot != null:
			slot_datas[empty_slot] = slot_data
			inventory_updated.emit(self)
			able_to_equip = true
			
	return able_to_equip

func unequip_item(index: int):
	var slot_data = slot_datas[index].duplicate()
	PlayerManager.unequip_slot_data(slot_data)
	slot_datas[index].item_data = null
	inventory_updated.emit(self)
