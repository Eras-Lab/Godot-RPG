extends Node

class_name ai_requests

@onready var http_request = $"../HTTPRequest"
@onready var player = $".."
@onready var battle_status = $"../battle_status"
@onready var transaction_manager = $"../TransactionManager"
@onready var action_functions = $"../ActionFunctions"
@onready var area_detection_handler = $"../AreaDetectionHandler"
@onready var action_manager = $"../ActionManager"


# Called when the node enters the scene tree for the first time.
func _ready():
	http_request.request_completed.connect(_on_http_request_request_completed)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	
func send_request(prompt_input: String):
	var headers = ["Content-Type: application/json"]
	print("action requested")
	#TODO: Connect with Nodes that have these datas stored
#	var players_nearby = area_detection_handler.players_nearby
#	var buildings_nearby = area_detection_handler.buildings_nearby
#	var items_nearby = area_detection_handler.items_nearby
#	var monsters_nearby = area_detection_handler.monsters_nearby
	
	#TODO: Get these observation data
	var current_location
	var current_currency_amount
	var current_inventory
	
	
	var body = {
		"player_id": self.get_parent().name,
		"npc_desc": "Test",
		"location": current_location,
		"inventory": current_inventory,
		"message": prompt_input,
		"funds": current_currency_amount,
#		"monsters_nearby": monsters_nearby,
#		"players_nearby": players_nearby,
#		"buildings_nearby": buildings_nearby,
#		"items_nearby": items_nearby,
	}
	var body_text = JSON.stringify(body)  # use JSON.print() to convert dict to JSON string
	http_request.request("http://127.0.0.1:5000/chat", headers, HTTPClient.METHOD_POST, body_text)

func _on_http_request_request_completed(result, response_code, headers, body):
	var action_name = null
	var res = str_to_var(body.get_string_from_utf8())

	print("=== API Response: ",res)
	
	if !res.has("name") or !res.has("arguments"):
		print("Did not return function")
	
	# parse the arguments field as a separate JSON string
	var arguments = JSON.parse_string(res["arguments"]) if res.has("arguments") else []
	action_name = res["name"] if res.has("name") else null
	print("action_name : ", action_name)
	
	if action_name == "walk_to":
		var location_name = arguments["location_name"]
		print("Location name:", location_name)
		# Call "walk_towards" function with given location_name argument
		action_manager.add_action(action_functions, "wrapped_walk_towards", [location_name], true)
		
	elif action_name == "pick_up_item":
		var item_name = arguments["item_name"]
		print("Item to pick up", item_name)
		action_manager.add_action(action_functions, "wrapped_pick_up_item")
		
	elif action_name == "trade":
#		var shop_name = arguments["shop_name"]
#		var item_name = arguments["item_name"]
#		print("Shop name", shop_name)
#		print("Item name", item_name)		
		action_manager.add_action(action_functions, "wrapped_trade")
		
	elif action_name == "buy_item":
		var item_name = arguments["item_name"]
		var external_store = arguments["external_store"]
		var external_currency_manager = arguments["external_currency_manager"]
		var quantity = arguments["quantity"]
		#TODO find "external_store" and "external_currency_manager" node given their "string_names"
		action_manager.add_action(action_functions, "wrapped_buy_item", [item_name, quantity, external_store, external_currency_manager])
			
	elif action_name == "train":
		var training_location_name = arguments["training_location_name"]
		action_manager.add_action(action_functions, "wrapped_train", [training_location_name])
	
	elif action_name == "craft":
		var first_item_name = arguments["first_item_name"]
		var second_item_name = arguments["second_item_name"]
		action_manager.add_action(action_functions, "wrapped_craft")
		
	elif action_name == "talk_to":
		var listener_id = arguments["listener_id"]
		var message = arguments["message"]
		action_manager.add_action(action_functions, "wrapped_talk_to", [listener_id, message])
	
	else:
		action_manager.add_action(action_functions, "wrapped_do_nothing", [])

	#TODO: Add remaining actions

