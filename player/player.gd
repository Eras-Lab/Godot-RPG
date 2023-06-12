extends CharacterBody2D

class_name Player

var inventory: InventoryData
var currency: CurrencyManager
var store: Store
var transaction_manager: TransactionManager

func _init(_inventory_data: InventoryData, _currency: CurrencyManager):
	inventory = _inventory_data
	currency = _currency
	store = Store.new(_inventory_data)
	transaction_manager = TransactionManager.new(inventory, currency)

func set_item_price_in_store(item: ItemData, price: int) -> void:
	store.set_item_price(item, price)

func get_item_price_in_store(item: ItemData) -> int:
	return store.get_item_price(item)

# Transact an item with another entity (either a Building or another Player)
func transact_item(item: ItemData, is_buying: bool, entity: Node) -> void:
	if entity is Building or entity is Player:
		if is_buying:
			transaction_manager.buy_item(entity.store, item)
		else:
			transaction_manager.sell_item(entity.store, item)
