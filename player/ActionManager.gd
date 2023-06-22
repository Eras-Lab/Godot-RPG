extends Node

class_name ActionManager

var action_queue := []  # Queue to store the actions. Each action is a dictionary.
var action_finished := true  # Flag to indicate if the current action has finished execution.
var current_action = null  # Stores the currently executing action.
var last_result = "Nothing new has happened." # Stores the result of the last action
const MAX_ACTIONS = 2  # Maximum number of actions that can be queued at one time.

@onready var ai_requests = $"../ai-requests"

# Triggers the next action in the queue once the previous action is finished.
func _physics_process(delta):
	if action_finished:
		if action_queue.size() > 0:
			current_action = action_queue.pop_front()
			current_action['object'].callv(current_action['func_name'], current_action['args'])
			action_finished = false
#		elif ai_requests != null:  # Currently handled in action_done()
#			ai_requests.send_request(last_result) 

# This function should be called from within every action method, once that action has completed.
func action_done(result):
	action_finished = true
	current_action = null  # Reset the current action.
	last_result = result
	# if queue is empty, get a new action (This would be better done in _physics_process so 
	# it can recover gracefully when the chain is broken, but it needs
	# more handling to make sure it doesn't get called repeatedly.)
	if action_queue.size() == 0:
		ai_requests.send_request(last_result) 

# Stops the current action if it has a 'stop_[func_name]' method. Always call this function 
# before starting a new interrupt action.
func stop_current_action():
	var stop_func_name = "stop_" + current_action['func_name']
	if current_action != null and current_action['object'].has_method(stop_func_name):
		current_action['object'].call(stop_func_name)
		current_action = null
		action_finished = true
		print("Current action ", current_action['func_name'], " stopped due to an interrupting action.")

# Add a new action to the action queue. Each action is represented as a dictionary with keys for object, 
# function name, arguments and whether the action is interruptible. Only adds 
# the action if the queue is not full.
func add_action(object, func_name, args=null, interruptible=false):
	print("Add Action called")
	if action_queue.size() < MAX_ACTIONS:
		action_queue.push_back({
			'object': object,
			'func_name': func_name,
			'args': args,
			'interruptible': interruptible
		})
		print("Action added: ", func_name)
	else:
		print("Action queue is full")

# Add an interrupt action to the front of the queue. Only add the interrupt action if the current 
# action is interruptible. Optionally clear the queue of existing actions.
func interrupt_with_action(clear_queue, object, func_name, args=null, interruptible=false):
	if action_queue.size() == 0 or current_action['interruptible']:
		stop_current_action()
		if clear_queue:
			action_queue.clear()
		action_queue.push_front({
			'object': object,
			'func_name': func_name,
			'args': args,
			'interruptible': interruptible 
		})
	else:
		print("Current action is not interruptible")
