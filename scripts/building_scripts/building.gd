extends StaticBody2D

var inventory: InventoryData
@onready var currency: CurrencyManager = $CurrencyManager
@onready var store: Store = $Store
@onready var transaction_manager: TransactionManager = $TransactionManager

func _ready():
	
	# initialize members
	inventory = InventoryData.new()
	inventory.slot_datas = []
	for i in range(10):
		inventory.slot_datas.append(SlotData.new())
	store.initialize(inventory)
	transaction_manager.initialize(inventory, currency)
	
	# give building gold to start with
	currency.increase_balance(1000)
	
	# add items to inventory
	inventory.add_slot_data(inventory.create_slot_data("Iron Sword", 2))
	inventory.add_slot_data(inventory.create_slot_data("Wooden Shield", 3))
	
	# add item prices to store 
	store.set_item_price("Iron Sword", 100)
	store.set_item_price("Wooden Shield", 200)
