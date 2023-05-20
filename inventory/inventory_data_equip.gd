extends InventoryData
class_name InventoryDataEquip

func drop_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	
	if not grabbed_slot_data.item_data is ItemDataEquip:
		return grabbed_slot_data
	
	return super.drop_slot_data_equip(grabbed_slot_data, index)

func drop_single_slot_data(grabbed_slot_data: SlotData, index: int) -> SlotData:
	if not grabbed_slot_data.item_data is ItemDataEquip:
		return grabbed_slot_data
	
	return super.drop_single_slot_data(grabbed_slot_data, index)

func grab_slot_data(index: int) -> SlotData:
	var slot_data = slot_datas[index]
	
	if slot_data:
		if slot_data.item_data is ItemDataEquip:
			unequip_slot_data(index)
		slot_datas[index] = null
		inventory_updated.emit(self)
		return slot_data
	else:
		return null
