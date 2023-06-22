extends Node

class_name ActionFunctions

@onready var battle_status = $"../battle_status"
@onready var player = $"../.."
@onready var transaction_manager = $"../TransactionManager"
@onready var action_manager = $"../ActionManager"

var min_distance = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func wrapped_walk_towards(location_name):
	battle_status.walk_towards(location_name)
	while battle_status.is_walking():
		await get_tree().process_frame 
	var action_result = "Player arrived at location " + str(location_name)
	print(action_result)
	action_manager.action_done(action_result) # necessary call when action completes

# Presence of a stop_[func name for action] method allows us to do things when the action is interrupted
func stop_wrapped_walk_towards():
	battle_status.stop_walking()

func wrapped_train(location_name):
	battle_status.walk_towards(location_name)
	if player.position.distance_to(battle_status.locations[location_name].position) <= min_distance:
		#yield(get_tree().create_timer(30.0), "timeout")
		var action_result = "Player trained at location " + str(location_name)
		print(action_result)
		action_manager.action_done(action_result)
		
func wrapped_buy_item(item_name, quantity, external_store, external_currency_manager):
	#TODO get external_store_node and external_currency_manager_node, given external_store string and external_currency_manager
	var external_store_node
	var  external_currency_manager_node
	transaction_manager.buy_item(item_name, quantity, external_store_node, external_currency_manager_node)
	var action_result = ""
	action_manager.action_done(action_result)
	
func wrapped_trade():
	# do something
	var action_result = ""
	action_manager.action_done(action_result)

func wrapped_pick_up_item():
	# do something
	var action_result = ""
	action_manager.action_done(action_result)

func wrapped_craft():
	# do something
	var action_result = ""
	action_manager.action_done(action_result)

