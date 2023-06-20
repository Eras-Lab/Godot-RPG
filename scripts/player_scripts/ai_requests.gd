extends Node

class_name ai_requests

@onready var http_request = $"../HTTPRequest"
@onready var player = $".."
@onready var battle_status = $"../battle_status"
@onready var transaction_manager = $"../TransactionManager"


# Called when the node enters the scene tree for the first time.
func _ready():
	http_request.request_completed.connect(_on_http_request_request_completed)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func send_request(user_input: String):
	var headers = ["Content-Type: application/json"]
	print("action requested")
	#TODO: Connect with Nodes that have these datas stored
	var body = {
		"player_id": self.get_parent().name,
		"npc_desc": "Test",
		"location": "park",
		"inventory": [],
		"message": user_input,
		"funds": 100
	}
	var body_text = JSON.stringify(body)  # use JSON.print() to convert dict to JSON string
	http_request.request("http://127.0.0.1:5000/chat", headers, HTTPClient.METHOD_POST, body_text)

func _on_http_request_request_completed(result, response_code, headers, body):
	var res = str_to_var(body.get_string_from_utf8())
	if res == null:
		self.send_request("did nothing")
		return
	print("=====response")
	print(res)
	
	# parse the arguments field as a separate JSON string
	var arguments = JSON.parse_string(res["arguments"])
	var action_name = res["name"]
	print("action_name : ", action_name)
	
	if action_name == "walk_to":
		var location_name = arguments["location_name"]
		print("Location name:", location_name)
		#Call "walk_towards" function with given location_name argument
		battle_status.walk_towards(location_name)
		
	elif action_name == "pick_up_item":
		var item_name = arguments["item_name"]
		print("Item to pick up", item_name)
		#TODO: Call "Pick up item function"
		
	
	elif action_name == "trade":
		var shop_name = arguments["shop_name"]
		var item_name = arguments["item_name"]
		#Call the function that would do the trade
		print("Shop name", shop_name)
		print("Item name", item_name)
		
	#TODO: Add remaining actions

	elif action_name == "buy_item":
		var item_name = arguments["item_name"]
		var external_store = arguments["external_store"]
		var external_currency_manager = arguments["external_currency_manager"]
		var quantity = arguments["quantity"]
		#TODO find "external_store" and "external_currency_manager" node given their "string_names"
		transaction_manager.buy_item(item_name, quantity, external_store, external_currency_manager)

	

