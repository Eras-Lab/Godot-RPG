extends Node

class_name ActionManager

var action_queue := []  # Queue to store the actions. Each action is a dictionary.
var action_finished := true  # Flag to indicate if the current action has finished execution.
var current_action = null  # Stores the currently executing action.
var results = []  # Stores recent action results
var is_paused = false  # Allows queue processing to pause and restart
var request_sent = false  # Flag to ensure only one request is sent when there are no more actions
const MAX_ACTIONS = 4  # Maximum number of actions that can be queued at one time
const MAX_RESULT_ACTIONS = 3 # Maximum number of action results to pass to API per request

@onready var ai_requests = $"../ai_requests"
@onready var player = $".."

func log_result(result: String):
	if !result.is_empty():
		results.push_front(result)
	
func format_results() -> String:
	var formatted_results = ""
	if results.is_empty():
		formatted_results = "No actions have been completed yet." #"You can walk to a building. If a building is nearby, you can train there. If a player is nearby, you can talk to that player." 
	else:
		var count = 0  
		for result in results:
			if count >= MAX_RESULT_ACTIONS:
				break  
			if typeof(result) == TYPE_STRING: 
				formatted_results += result + '\n'
				count += 1
	return formatted_results.trim_suffix("\n")  # Removes trailing newlines

# Triggers the next action in the queue once the previous action is finished.
func _physics_process(delta):
	if !is_paused and action_finished:
		if action_queue.size() > 0:
			current_action = action_queue.pop_front()
			var function = current_action['func_name']
			var args = current_action['args'] if current_action['args'] else []
			action_finished = false
			request_sent = false  # Reset the request_sent flag as a new action has started
			print("ACTION MANAGER | Calling: ", function, "(" + str(args) + ")")
			current_action['object'].callv(function, args)
		elif not request_sent:
			ai_requests.send_request(format_results()) 
			request_sent = true  # Set the request_sent flag as a request has been sent

# This function should be called from within every action method, once that action has completed.
func action_done(result: String):
	if current_action != null:
		print("ACTION MANAGER | ", player.name, " | Action ", current_action['func_name'], " done: ", result)  
	else:
		print("ACTION MANAGER | ", player.name, " | No current action to complete")
	action_finished = true
	current_action = null  # Reset the current action.
	log_result(result)

# Stops the current action if it has a 'stop_[func_name]' method. Always call this function 
# before starting a new interrupt action.
func stop_current_action():
	if current_action == null:
		return
	var stop_func_name = "stop_" + current_action['func_name']
	if current_action != null and current_action['object'].has_method(stop_func_name):
		current_action['object'].call(stop_func_name)
		print("ACTION MANAGER | ", player.name, " | Current action ", current_action['func_name'], " stopped due \
		to an interrupting action.")		
		current_action = null
		action_finished = true

# Add a new action to the action queue. Each action is represented as a dictionary with keys for object, 
# function name, arguments and whether the action is interruptible. Only adds 
# the action if the queue is not full.
func add_action(object, func_name, args=null, interruptible=false):
	if action_queue.size() < MAX_ACTIONS:
		action_queue.push_back({
			'object': object,
			'func_name': func_name,
			'args': args,
			'interruptible': interruptible
		})
		print("ACTION MANAGER | ", player.name, " | Action added: ", func_name)
	else:
		print("ACTION MANAGER | ", player.name, " | Action queue is full")
		
# Clears any actions in the queue that haven't started executing
func clear_queue():
	action_queue.clear()
	print("ACTION MANAGER |", player.name, " | Action queue cleared")
		
# Stops the current action, if possible, and pauses action processing.
func interrupt_and_pause():
	if action_queue.size() == 0 or (current_action != null and current_action['interruptible']):
		stop_current_action()
	else:
		print("ACTION MANAGER | ", player.name, " | Current action is not interruptible")
	pause()

# Add an interrupt action to the front of the queue. Only add the interrupt action if the current 
# action is interruptible. 
func interrupt_with_action(object, func_name, args=null, interruptible=false):
	if action_queue.size() == 0 or (current_action != null and current_action['interruptible']):
		stop_current_action()
		action_queue.push_front({
			'object': object,
			'func_name': func_name,
			'args': args,
			'interruptible': interruptible 
		})
	else:
		print("ACTION MANAGER | ", player.name, " | Current action is not interruptible")

# Prevents any new actions from being processed until unpaused		
func pause():
	is_paused = true
	print("ACTION MANAGER | ", player.name, " | Action processing paused")

# Resumes processing any actions in the queue
func unpause():
	is_paused = false
	print("ACTION MANAGER | ", player.name, " | Action processing unpaused")
