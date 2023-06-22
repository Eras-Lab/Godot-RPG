extends Node

class_name ActionFunctions

@onready var battle_status = $"../battle_status"
@onready var transaction_manager = $"../TransactionManager"
@onready var action_manager = $"../ActionManager"

var min_distance = 1
var training = false

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

func wrapped_walk_towards(location_name):
	battle_status.walk_towards(location_name)
	while battle_status.is_walking():
		await get_tree().process_frame 
	var action_result = "Player arrived at location " + str(location_name)
	action_manager.action_done(action_result) # necessary call when action completes

# Presence of a stop_[func name for action] method allows us to do things when the action is interrupted
func stop_wrapped_walk_towards():
	battle_status.stop_walking()

func wrapped_train(location_name):
	battle_status.walk_towards(location_name)
	while battle_status.is_walking():
		await get_tree().process_frame 
	training = true
	var rounds = 0
	while training and rounds < 10:
		await get_tree().create_timer(1).timeout
		rounds += 1
	if(!training): 
		return
	training = false
	var action_result = "Player trained at location " + location_name
	action_manager.action_done(action_result)

func stop_wrapped_train():
	training = false
		
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
	
func wrapped_talk_to(listener_id, message):
	var MAX_DISTANCE_TO_TALK = 1
	var player = self.get_parent()
	var listener = get_node("/root/world/" + listener_id)
	
	if listener == null:
		print("Invalid listener_id provided to talk_to action")
		action_manager.action_done(null)
		return
	
	# Make sure the players are near each other
	if player.position.distance_to(listener.position) < MAX_DISTANCE_TO_TALK:
		print(player, " will now try to talk to ", listener)
		
		# Freeze the listener
		listener.action_manager.interrupt_and_pause()
		# We could also clear the listener's queue if needed
		# listener.action_manager.clear_queue()
		
		# Show the conversation (this is just a temporary solution, needs a better UI)
		var text_label = Label.new()  # Create a new Label instance
		text_label.text = message  # Set the text of the Label
		text_label.position = player.position  # Set the position of the Label
		add_child(text_label)  # Add the Label as a child of the current node

		# Pause for the conversation to happen
		await get_tree().create_timer(6).timeout
		
		text_label.queue_free() 
		
		# Send the result of the conversation to the player's action manager
		var player_action_result = "Player had the following conversation with " + listener_id + ": " + message
		action_manager.action_done(player_action_result)
		# Could also add new action to player as a result of the conversation
		# player.add_action()
		
		# Send the result of the conversation to the other player's action manager
		var listener_action_result = "Player had the following conversation with " + player.name + ": " + message
		listener.action_manager.action_done(listener_action_result)
		# Unfreeze the listener
		listener.action_manager.unpause()
		# Could also add new action to listener as a result of the conversation
		#listener.add_action()
		
func wrapped_do_nothing():
	await get_tree().create_timer(5).timeout
	action_manager.action_done("")
	
