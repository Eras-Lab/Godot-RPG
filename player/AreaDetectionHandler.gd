extends Node

var players_nearby = []
var buildings_nearby = []
var items_nearby = []
var monsters_nearby = []

@onready var detection_area = $"../AnimatedSprite2D/detection_area"

# Called when the node enters the scene tree for the first time.
func _ready():
	detection_area.connect("body_entered", _on_detection_area_body_entered)
	detection_area.connect("body_exited", _on_detection_area_body_exited)
	print("Area Detection Node Ready")

# MARKET
func _on_detection_area_body_entered(body):
	if body == self.get_parent():
		return
	
	if body.has_method("is_player"):  # or check for some player-specific property
		players_nearby.append(body)
	elif body.has_method("is_building"):  # or check for some building-specific property
		buildings_nearby.append(body)
	elif body.has_method("is_item"):  # or check for some item-specific property
		items_nearby.append(body)
	elif body.has_method("is_monster"):  # or check for some monster-specific property
		monsters_nearby.append(body)

func _on_detection_area_body_exited(body):
	if body in players_nearby:
		players_nearby.erase(body)
	elif body in buildings_nearby:
		buildings_nearby.erase(body)
	elif body in items_nearby:
		items_nearby.erase(body)
	elif body in monsters_nearby:
		monsters_nearby.erase(body)
