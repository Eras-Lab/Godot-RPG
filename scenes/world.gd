extends Node2D

const PickUp = preload("res://item/pick_up.tscn")

@onready var player = $player
@onready var inventory_interface = $UI/InventoryInterface
@onready var garrick_stormwind = $GarrickStormwind
@onready var lyra_shadowheart = $LyraShadowheart
@onready var grimgar_stonebeard = $GrimgarStonebeard
@onready var morgath_darkbane = $MorgathDarkbane
@onready var freya_swiftwind = $FreyaSwiftwind

@onready var dungeon_camera = $DungeonCamera
@onready var town_camera = $TownCamera


func _ready():
	global.current_location = global.Location.TOWN
	town_camera.make_current()
	garrick_stormwind.toggle_inventory.connect(toggle_inventory_interface)
	
	inventory_interface.set_player_inventory_data(garrick_stormwind.inventory_data, 1)
	garrick_stormwind.inventory_data.set_player(1)
	garrick_stormwind.equip_inventory_data.set_player(1)
	inventory_interface.set_equip_inventory_data(garrick_stormwind.equip_inventory_data, 1)
	
	inventory_interface.set_player_inventory_data(lyra_shadowheart.inventory_data, 2)
	lyra_shadowheart.inventory_data.set_player(2)
	lyra_shadowheart.equip_inventory_data.set_player(2)
	inventory_interface.set_equip_inventory_data(lyra_shadowheart.equip_inventory_data, 2)
	
	inventory_interface.set_player_inventory_data(grimgar_stonebeard.inventory_data, 3)
	grimgar_stonebeard.inventory_data.set_player(3)
	grimgar_stonebeard.equip_inventory_data.set_player(3)
	inventory_interface.set_equip_inventory_data(grimgar_stonebeard.equip_inventory_data, 3)
	
	inventory_interface.set_player_inventory_data(morgath_darkbane.inventory_data, 4)
	morgath_darkbane.inventory_data.set_player(4)
	morgath_darkbane.equip_inventory_data.set_player(4)
	inventory_interface.set_equip_inventory_data(morgath_darkbane.equip_inventory_data, 4)
	
	inventory_interface.set_player_inventory_data(freya_swiftwind.inventory_data, 5)
	freya_swiftwind.inventory_data.set_player(5)
	freya_swiftwind.equip_inventory_data.set_player(5)
	inventory_interface.set_equip_inventory_data(freya_swiftwind.equip_inventory_data, 5)
		
	for node in get_tree().get_nodes_in_group("external_inventory"):
		node.toggle_inventory.connect(toggle_inventory_interface)
		
func toggle_inventory_interface(external_inventory_owner = null) -> void:
	inventory_interface.visible = not inventory_interface.visible
	
#	if inventory_interface.visible:
#		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
#	else:
#		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if external_inventory_owner and inventory_interface.visible:
		inventory_interface.set_external_inventory(external_inventory_owner)
	else:
		inventory_interface.clear_external_inventory()
	
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


func _on_inventory_interface_drop_slot_data(slot_data):
	var pick_up = PickUp.instantiate()
	pick_up.slot_data = slot_data
	pick_up.global_position = player.get_drop_position()
	add_child(pick_up)
	
func _on_teleport_to_dungeon_pressed():
	var shouldAppear = false
	global.current_location = global.Location.DUNGEON
	if is_instance_valid(garrick_stormwind):
		if shouldAppear:
			garrick_stormwind.global_position = Vector2(4500, 30)
	if is_instance_valid(lyra_shadowheart):
		if shouldAppear:
			lyra_shadowheart.global_position = Vector2(4500, 50)
	if is_instance_valid(grimgar_stonebeard):
		if shouldAppear:
			grimgar_stonebeard.global_position = Vector2(4500, 70)
	if is_instance_valid(morgath_darkbane):
		if shouldAppear:
			morgath_darkbane.global_position = Vector2(4500, 90)
	if is_instance_valid(freya_swiftwind):
		freya_swiftwind.global_position = Vector2(4500, 110)
	dungeon_camera.make_current()

func _on_teleport_to_town_pressed():
	global.current_location = global.Location.TOWN
	if is_instance_valid(garrick_stormwind):
		garrick_stormwind.global_position = Vector2(520, 290)
	if is_instance_valid(lyra_shadowheart):
		lyra_shadowheart.global_position = Vector2(520, 310)
	if is_instance_valid(grimgar_stonebeard):
		grimgar_stonebeard.global_position = Vector2(500, 270)
	if is_instance_valid(morgath_darkbane):
		morgath_darkbane.global_position = Vector2(500, 290)
	if is_instance_valid(freya_swiftwind):
		freya_swiftwind.global_position = Vector2(500, 310)
	town_camera.make_current()
