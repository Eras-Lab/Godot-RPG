extends Node

var players_nearby = []
var buildings_nearby = []
var items_nearby = []
var monsters_nearby = []

#@onready var detection_area = $"../AnimatedSprite2D/detection_area"
@onready var default_detection_area = $"../AnimatedSprite2D/detection_area"
var detection_area = null : set = set_detection_area

# Called when the node enters the scene tree for the first time.
func _ready():
#	detection_area.connect("body_entered", _on_detection_area_body_entered)
#	detection_area.connect("body_exited", _on_detection_area_body_exited)
	set_detection_area(default_detection_area)

func _on_detection_area_body_entered(body):
	if body == self.get_parent():
		return
	
	if body.has_method("is_player"):  # or check for some player-specific property
		players_nearby.append(body)
		print("AREA DETECTION | Player " + str(body) + " in area of ", self.get_parent().name)
	elif body.has_method("is_building"):  # or check for some building-specific property
		buildings_nearby.append(body)
		print("AREA DETECTION | Building " + str(body) + " in area of ", self.get_parent().name)
	elif body.has_method("is_item"):  # or check for some item-specific property
		items_nearby.append(body)
		print("AREA DETECTION | Item " + str(body) + " in area of ", self.get_parent().name)
	elif body.has_method("is_monster"):  # or check for some monster-specific property
		monsters_nearby.append(body)
		print("AREA DETECTION | Monster " + str(body) + " in area of ", self.get_parent().name)

func _on_detection_area_body_exited(body):
	if body in players_nearby:
		players_nearby.erase(body)
	elif body in buildings_nearby:
		buildings_nearby.erase(body)
	elif body in items_nearby:
		items_nearby.erase(body)
	elif body in monsters_nearby:
		monsters_nearby.erase(body)
		
# Setter for detection_area.
func set_detection_area(new_area):
	if detection_area:
		# Disconnect the signals from the current area, if it exists.
		detection_area.disconnect("body_entered", _on_detection_area_body_entered)
		detection_area.disconnect("body_exited", _on_detection_area_body_exited)
	# Assign the new area.
	detection_area = new_area
	# Connect the signals for the new area.
	if detection_area:
		detection_area.connect("body_entered", _on_detection_area_body_entered)
		detection_area.connect("body_exited", _on_detection_area_body_exited)
		print("AREA DETECTION | Signals connected for " + self.get_parent().name)
		
func print_nearby():
	print("AREA DETECTION | Nearby: ")
	print("Players nearby:")
	for player in players_nearby:
		print("\t", player)
	
	print("Buildings nearby:")
	for building in buildings_nearby:
		print("\t", building)
	
	print("Items nearby:")
	for item in items_nearby:
		print("\t", item)

	print("Monsters nearby:")
	for monster in monsters_nearby:
		print("\t", monster)

