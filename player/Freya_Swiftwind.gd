extends CharacterBody2D

signal toggle_inventory

@export var inventory_data: InventoryData
@export var equip_inventory_data: InventoryDataEquip
@onready var health_bar = $HealthBar
@onready var movement = $Movement

signal go_and_attack

var monster_chase = false
var enemy

var monsters_defeated = false
var enemy_in_attackrange = false
var enemy_attack_cooldown = true
var walking_towards = "none"

var player_name = "Garrick Stormwind"

#player stats
var max_health = 1300
var health = 1300
var attack_damage = 10
var defense = 10
var stamina = 10
var strength = 10
var constitution = 10
var dexterity = 10
var intelligence = 10

var player_alive = true

var attack_ip = false

const speed = 100
var current_dir = "none"

var buildings = null
var locations = null
var monsters = null

enum Direction { UP, DOWN, LEFT, RIGHT, NONE }

var current_direction = Direction.NONE
var step_size = 1

var current_action = null
@onready var buildings_list = $"../Buildings"
@onready var monsters_list = $"../DungeonMonsters"

@onready var chain_http_req = HTTPRequest.new()


func _ready():
	PlayerManager.players.push_back(self)
	health_bar.max_value = max_health
	$AnimatedSprite2D.play("front_idle")
	buildings = buildings_list.get_children()
	monsters = monsters_list.get_children()
	locations = {}
	for building in buildings:
		print(building)
		locations[building.name] = building		
	movement.walk_towards(locations, "Building5")


func _physics_process(delta):
	update_healthbar()
#	player_movement(delta)
	movement.player_movement(delta, speed)
	enemy_attack()
	pickup()
	current_camera()
	if walking_towards != "none" and global.current_location == global.Location.TOWN:
		# walk_towards(walking_towards)
		movement.walk_towards(locations, walking_towards)
	
	if global.current_location == global.Location.DUNGEON:
		go_and_attack.emit(current_direction)
			
	if health <= 0:
		player_alive = false
		health = 0
		print("player has died")
		self.queue_free()


func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		enemy_in_attackrange = true


func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_attackrange = false

func enemy_attack():
	if enemy_in_attackrange and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		
		$attack_cooldown.start()
	
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
	

func heal(heal_value: int) -> void:
	health += heal_value

func equip(stats) -> void:
	if stats["attack_damage"]:
		attack_damage += stats["attack_damage"]
	
	if stats["strength"]:
		strength += stats["strength"]
	
	if stats["constitution"]:
		constitution += stats["constitution"]


func update_healthbar():
	health_bar.value = health
	
func increase_attack_damage(amount):
	attack_damage += amount
	print("Player", self.name)
	print("attack increased to", self.attack_damage)

func increase_strength(amount):
	strength += amount
	print("Player", self.name)
	print("strength increased to", self.strength)	
	
func increase_health(amount):
	health += amount
	print("Player", self.name)
	print("health increased to", self.health)	

func increase_constitution(amount):
	constitution += amount
	print("Player", self.name)
	print("constitution increased to ", self.constitution)

	
func _on_req_completed(result, response_code, headers, body):
	pass
