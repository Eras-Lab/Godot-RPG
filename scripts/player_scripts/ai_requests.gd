extends Node

class_name ai_requests

@onready var http_request = $"../HTTPRequest"
@onready var player = $".."
@onready var battle_status = $"../battle_status"
@onready var transaction_manager = $"../TransactionManager"
@onready var action_functions = $"../ActionFunctions"
@onready var area_detection_handler = $"../AreaDetectionHandler"
@onready var action_manager = $"../ActionManager"

# Called when the node entefdid nrs the scene tree for the first time.
func _ready():
	http_request.request_completed.connect(_on_http_request_request_completed)	
	
func send_request(prompt_input: String):
	var headers = ["Content-Type: application/json"]
	
	#TODO: Connect with Nodes that have these datas stored
	var players_nearby = area_detection_handler.players_nearby
	var buildings_nearby = area_detection_handler.buildings_nearby
	var items_nearby = area_detection_handler.items_nearby
	var monsters_nearby = area_detection_handler.monsters_nearby
	
	#TODO: Get these observation data
	var current_location
	var current_currency_amount
	var current_inventory
	
	var body = {
		"player_id": player.name,
		"npc_desc": "Test",
		"location": current_location,
		"inventory": current_inventory,
		"message": prompt_input,
		"funds": current_currency_amount,
		"monsters_nearby": monsters_nearby,
		"players_nearby": players_nearby,
		"buildings_nearby": buildings_nearby,
		"items_nearby": items_nearby,
	}
	var body_text = JSON.stringify(body)  # use JSON.print() to convert dict to JSON string
	http_request.request("http://127.0.0.1:5000/chat", headers, HTTPClient.METHOD_POST, body_text)
	print("=== API REQUEST | ", player.name, " | ", body_text)

func _on_http_request_request_completed(result, response_code, headers, body):
	var action_name : String = ""
	var arguments = null
	var res = str_to_var(body.get_string_from_utf8())

	print("=== API RESPONSE: | ", player.name , " | ", res)
	
	var transformed_res = null
	if res == null:
		print("API RESPONSE | Did not return response")
	else:
		transformed_res = transform_response(res)
	
	if transformed_res and transformed_res.has("name") and transformed_res.has("arguments"):
		# parse the arguments field as a separate JSON string
		arguments = JSON.parse_string(transformed_res["arguments"]) if transformed_res.has("arguments") else []
		action_name = transformed_res["name"] if transformed_res.has("name") else null
		print("API RESPONSE | Returned action: ", action_name)
	else:
		print("API RESPONSE | Did not return function")
	
	if action_name == "walk_to":
		var location_name = arguments["location_name"]
#		print("Location name:", location_name)
		# Call "walk_towards" function with given location_name argument
		action_manager.add_action(action_functions, "wrapped_walk_towards", [location_name], true)
		
	elif action_name == "pick_up_item":
#		var item_name = arguments["item_name"]
#		print("Item to pick up", item_name)
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
	

func transform_response(response: Dictionary) -> Dictionary:
	# Check if response is in the second format
	if response.has("role") and response.has("content"):
		var json_str = response["content"]
#		print("content_str: ", content_str)

		# Check if json_str looks like it could contain a JSON object
		if json_str.begins_with("{") and json_str.find("}") != -1:
			# Cut off everything after the final }
			json_str = json_str.substr(0, json_str.rfind("}") + 1)
#			print("trimmed_json_str: ", json_str)

			var json = JSON.new()
			var error = json.parse(json_str)

			# Check if the parsing was successful
			if error == OK:
				var content_dict = json.get_data()
#				print("content_dict: ", content_dict)

				# Extract the action name and arguments from the dictionary
				var action_name = content_dict.keys()[0]
				var arguments = content_dict[action_name]

				# Format arguments as a JSON string
				var arguments_str = JSON.stringify(arguments)

				# Return transformed response
				return {"name": action_name, "arguments": arguments_str}
				
			else:
				print("JSON Parse Error: ", json.get_error_message(), " in ", json_str, " at line ", json.get_error_line())

	# If response is not in the second format, or parsing failed, return it as is
	return response





