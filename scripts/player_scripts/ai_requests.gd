extends Node

class_name ai_requests

@onready var http_request = $"../HTTPRequest"
@onready var player = $".."
@onready var battle_status = $"../battle_status"

# Called when the node enters the scene tree for the first time.
func _ready():
	http_request.request_completed.connect(_on_http_request_request_completed)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func send_request(user_input: String):
	var headers = ["Content-Type: application/json"]
	print("action requested")
	var body = {
		"npc_name": self.get_parent().name,
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
	var response = JSON.parse_string(res)	
	
	if response.action.type == "walkTo":
		player.current_action = "walking"
		var location_name = response.action.where
		print("walking to " + location_name)
		battle_status.walk_towards(location_name)
		self.send_request("Just walked to " + location_name)
				
	elif response.action.type == "wait":
		print("WAITING")
		self.send_request("Just Waited")
