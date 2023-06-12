extends Node

class_name TransactionManager

var inventory : InventoryData
var currency : CurrencyManager
#var store : Store  # Reference to the store to interact with

func _init(_inventory : InventoryData,_currency : CurrencyManager):
	inventory = _inventory
	currency = _currency
	
#func set_store(_store : Store):
#	store = _store

func buy_item(store : Store, item_data : ItemData):
	var price = store.get_item_price(item_data)
	if currency.get_balance() >= price:
		var item = store.store_inventory.grab_slot_data(store.store_inventory.slot_datas.find(item_data))
		if item:
			inventory.pick_up_slot_data(item)
			currency.decrease_balance(price)

func sell_item(store : Store, item_data : ItemData):
	var price = store.get_item_price(item_data)
	if price > 0:
		var index = inventory.slot_datas.find(item_data)
		if index != -1:
			var item = inventory.grab_slot_data(index)
			store.store_inventory.pick_up_slot_data(item)
			currency.increase_balance(price)
