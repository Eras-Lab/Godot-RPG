extends CharacterBody2D

signal toggle_inventory

@export var inventory_data: InventoryData
@export var equip_inventory_data: InventoryDataEquip
@export var head: InventoryDataEquip
@onready var health_bar = $HealthBar

var enemy
var enemy_attack_cooldown = true
var walking_towards = "none"
# var monster_chase = false

var player_alive = true

var attack_ip = false

var current_dir = "none"

enum Direction { UP, DOWN, LEFT, RIGHT, NONE }

var current_direction = Direction.NONE
var step_size = 1

var current_action = null
@onready var buildings_list = $"../Buildings"
@onready var monsters_list = $"../DungeonMonsters"
@onready var http_request = $HTTPRequest
@onready var chain_http_req = HTTPRequest.new()
@onready var player_animation = $PlayerAnimation
@onready var character_inventory = $InventoryInterface/CharacterInventory/Inventory
@onready var equip_inventory = $InventoryInterface/EquipInventory/Inventory

@onready var play_anim = $play_anim
@onready var player_status = $player_status
@onready var battle_status = $battle_status
@onready var ai_requests = $"ai-requests"

# MARKET
var external_store = null
var external_currency_manager = null
@onready var currency_manager = $CurrencyManager
@onready var store = $Store
@onready var transaction_manager = $TransactionManager
@onready var buy_button = $BuyButton
# END MARKET	

func _ready():
	PlayerManager.set_player(self)
	health_bar.max_value = player_status.max_health
	$AnimatedSprite2D.play("front_idle")
	battle_status.walk_towards("Building5")
	
	character_inventory.set_inventory_data(inventory_data)
	equip_inventory.set_inventory_data(equip_inventory_data)
	
	# MARKET
	# store and tx manager have to be initialized
	store.initialize(inventory_data)
	transaction_manager.initialize(inventory_data, currency_manager)
	
	# set prices for items I want to sell
	store.set_item_price("Health Potion", 300)
	
	# give myself some money to start with
	currency_manager.increase_balance(1000)
	
	# ui setup
	var detection_area = find_child("detection_area", true, false)
	detection_area.connect("body_entered", _on_detection_area_body_entered)
	detection_area.connect("body_exited", _on_detection_area_body_exited)
	if buy_button:
		buy_button.connect("pressed", _on_buy_button_pressed)
		buy_button.visible = false
	# END MARKET
	
	#drink health potion
	inventory_data.use_slot_data(5)
	
	#equip wooden shield
	inventory_data.equip_slot_data(1)
	
	#equip iron sword
	inventory_data.equip_slot_data(0)
	
	#equip iron helmet
	inventory_data.equip_slot_data(3)
	
	#equip steel helmet
	#This should not work because a helmet is already equipped
	inventory_data.equip_slot_data(4)
	
	#unequip iron sword
	equip_inventory_data.unequip_item(1)

func _physics_process(delta):
	update_healthbar()
	play_anim.play_anim(current_direction, 0, attack_ip)
	current_camera()
	battle_status.enemy_attack(1) #TODO: Change to be called from Enemy	
	pickup()
	if walking_towards != "none" and global.current_location == global.Location.TOWN:
		battle_status.walk_towards(walking_towards)
	
	if global.current_location == global.Location.DUNGEON:
		battle_status.go_and_attack(enemy)

	if player_status.health <= 0:
		player_alive = false
		player_status.health = 0
		print("player has died")
		self.queue_free()
	
func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		battle_status.enemy_in_attackrange = true

func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		battle_status.enemy_in_attackrange = false

	
func player():
	pass
	
func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func pickup():
	if Input.is_action_just_pressed("interact"):
		print("interact button pressed")

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false

func current_camera():
	if global.current_scene == "world":
		$world_camera.enabled = true
		$cliffside_camera.enabled = false
	elif global.current_scene == "cliff_side":
		$world_camera.enabled = false
		$cliffside_camera.enabled = true

func _on_line_edit_text_submitted(new_text):
	print(new_text)
	global.player_talking = true
	global.plyaer_message = new_text
	var json = JSON.stringify(new_text)
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request("http://localhost:5000/openai", headers, HTTPClient.METHOD_POST, json)

func _unhandled_input(event):
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
		
func get_drop_position():
	var dir = current_dir
	
	if dir == "none":
		return position + Vector2(0, 35)
	if dir == "right":
		return position + Vector2(35, 0)
	if dir == "left":
		return position + Vector2(-35, 0)
	if dir == "up":
		return position + Vector2(0, -35)
	if dir == "down":
		return position + Vector2(0, 35)
		
func update_healthbar():
	health_bar.value = player_status.health

	
func _on_req_completed(result, response_code, headers, body):
	pass
	
# MARKET
func _on_detection_area_body_entered(body):
	if body == self:
		return
	if body.has_node("Store"):
		external_store = body.get_node("Store")
		print("New store found by Garrick: ", external_store.item_prices)
		if buy_button:
			buy_button.visible = true
	if body.has_node("CurrencyManager"): # not all entities with stores need to have currency
		external_currency_manager = body.get_node("CurrencyManager")

func _on_detection_area_body_exited(body):
	if body.has_node("Store"): # only leave the store if leaving an element that has a store
		external_store = null
		external_currency_manager = null
		print("Left store")
		if buy_button:
			buy_button.visible = false

func _on_buy_button_pressed():
	transaction_manager.buy_item("Health Potion", 2, external_store, external_currency_manager)
# END MARKET
