extends Node


@onready var battle_status = $"../../battle_status"
@onready var player = $"../.."
@onready var ai_requests = $".."
@onready var transaction_manager = $"../../TransactionManager"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func wrapped_walk_towards(location_name):
	battle_status.walk_towards(location_name)
	if player.distance_to(battle_status.locations[location_name].position) <= battle_status.min_distance:
		ai_requests.send_request("Player arrived at location " + str(location_name))

func wrapped_train(location_name):
	battle_status.walk_towards(location_name)
	if player.distance_to(battle_status.locations[location_name].position) <= battle_status.min_distance:
		#yield(get_tree().create_timer(30.0), "timeout")
		ai_requests.send_request("Player trained at location " + str(location_name))
		
func wrapped_buy_item(item_name, quantity, external_store, external_currency_manager):
	#TODO get external_store_node and external_currency_manager_node, given external_store string and external_currency_manager
	var external_store_node
	var  external_currency_manager_node
	transaction_manager.buy_item(item_name, quantity, external_store_node, external_currency_manager_node)
	
func wrapped_trade():
	pass

func wrapped_pick_up_item():
	pass

func wrapped_craft():
	pass
