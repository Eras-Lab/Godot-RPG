extends Node

var players_in_area = []
var buildings_in_area = []
var items_in_area = []
var monsters_in_area = []

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
		players_in_area.append(body)
	elif body.has_method("is_building"):  # or check for some building-specific property
		buildings_in_area.append(body)
	elif body.has_method("is_item"):  # or check for some item-specific property
		items_in_area.append(body)
	elif body.has_method("is_monster"):  # or check for some monster-specific property
		monsters_in_area.append(body)

func _on_detection_area_body_exited(body):
	if body in players_in_area:
		players_in_area.erase(body)
	elif body in buildings_in_area:
		buildings_in_area.erase(body)
	elif body in items_in_area:
		items_in_area.erase(body)
	elif body in monsters_in_area:
		monsters_in_area.erase(body)
