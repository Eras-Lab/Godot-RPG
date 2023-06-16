extends Node

class_name TransactionManager

var inventory : InventoryData
var currency : CurrencyManager
	
func initialize(_inventory: InventoryData, _currency: CurrencyManager):
	inventory = _inventory
	currency = _currency

## Transfers the specified quantity of the specified item from an external store to inventory, 
## and decreases the currency balance by the total cost. External currency can be null if
## the entity, a building for example, doesn't need to track its own gold balance.
func buy_item(item_name: String, quantity: int, 
external_store: Store, external_currency: CurrencyManager) -> bool:
	print("Attempting to buy: ", quantity, " of item: ", item_name)
	print("Buying from store: ", external_store, " with prices: ", external_store.item_prices)
	print("and with inventory: ")
	for slot_data in external_store.inventory.slot_datas:	
		if slot_data.item_data:
				print("Item: ", slot_data.item_data.name, ", Quantity: ", slot_data.quantity)
	var item_price = external_store.get_item_price(item_name)
	if item_price < 0:
		print("Item not found in store")
		return false
	var total_price = item_price * quantity
	print("Total price: ", total_price)
	if currency.get_balance() < total_price:
		print("Insufficient funds for purchase. Balance: ", currency.get_balance())
		return false
	var slot_data = external_store.inventory.remove_slot_data(item_name, quantity)
	if not slot_data:
		print("Insufficient item quantity in inventory.")
		return false
	inventory.add_slot_data(slot_data)
	currency.decrease_balance(total_price)
	if external_currency:
		external_currency.increase_balance(total_price)
	print("Item puchased. New balance: ", currency.get_balance())
	return true
	
