extends Node
#TODO: We should have an array list of: [shops] , [players], [items] and [monsters] that enters and exit the detection area

#@onready var detection_area = $"../AnimatedSprite2D/detection_area"
@onready var detection_area = $"../AnimatedSprite2D/detection_area"


# Called when the node enters the scene tree for the first time.
func _ready():
	# Replace with function body.
	detection_area.connect("body_entered", _on_detection_area_body_entered)
	detection_area.connect("body_exited", _on_detection_area_body_exited)
	print("test Area Detection Node")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#TODO Create a Node for dealing with "Area_body_detection"
# MARKET
func _on_detection_area_body_entered(body):
	print("BODY THAT ENTERED AREA", body)
	if body == self:
		return
	#TODO: Add list for stores
	#TODO: Add other checks for entered area (players, monsters, items)
	if body.has_node("Store"):
		#external_store = body.get_node("Store")
		#print("New store found by Garrick: ", external_store.item_prices)
		print("External Store Detected")

	#if body.has_node("CurrencyManager"): # not all entities with stores need to have currency
		#external_currency_manager = body.get_node("CurrencyManager")

func _on_detection_area_body_exited(body):
	print("BODY THAT EXITED AREA", body)
	if body.has_node("Store"): # only leave the store if leaving an element that has a store
		#external_store = null
		#external_currency_manager = null
		print("Left store")
