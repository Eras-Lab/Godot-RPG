extends Node2D

const PickUp = preload("res://item/pick_up.tscn")

@onready var garrick_stormwind = $GarrickStormwind
@onready var freya_swiftwind = $FreyaSwiftwind

@onready var dungeon_camera = $DungeonCamera
@onready var town_camera = $TownCamera

func _ready():
	global.current_location = global.Location.TOWN
	town_camera.make_current()

func toggle_inventories():
	var inventory = garrick_stormwind.get_node("InventoryInterface")
	inventory.visible = not inventory.visible
	
	#will add inventories for other characters here as well

func _unhandled_input(event):
	if Input.is_action_pressed("inventory"):
		toggle_inventories()
	
func _process(delta):
	change_scene()

func _on_cliffside_transition_point_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true

func _on_cliffside_transition_point_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
			global.game_first_loadin = false
			global.finish_changescenes()

func _on_teleport_to_dungeon_pressed():
	global.current_location = global.Location.DUNGEON
	if is_instance_valid(garrick_stormwind):
		garrick_stormwind.global_position = Vector2(4500, 30)
	if is_instance_valid(freya_swiftwind):
		freya_swiftwind.global_position = Vector2(4500, 110)
	dungeon_camera.make_current()

func _on_teleport_to_town_pressed():
	global.current_location = global.Location.TOWN
	if is_instance_valid(garrick_stormwind):
		garrick_stormwind.global_position = Vector2(520, 290)
	if is_instance_valid(freya_swiftwind):
		freya_swiftwind.global_position = Vector2(500, 310)
	town_camera.make_current()
