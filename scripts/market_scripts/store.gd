extends Node

class_name Store

var inventory: InventoryData
var item_prices: Dictionary = {}
	
func initialize(inventory_data: InventoryData):
	inventory = inventory_data
	
func set_item_price(item_name: String, price : int):
	if item_name:
		item_prices[item_name] = price
	
func get_item_price(item_name: String) -> int:
	return item_prices.get(item_name, -1)
