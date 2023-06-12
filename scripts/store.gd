extends Node

class_name Store

var store_inventory : InventoryData
var item_prices = {}

func _init(inventory_data: InventoryData):
	store_inventory = inventory_data
	
func set_item_price(item_data : ItemData, price : int):
	item_prices[item_data] = price
	
func get_item_price(item_data : ItemData) -> int:
	return item_prices.get(item_data, 0)
