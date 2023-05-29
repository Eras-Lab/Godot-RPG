extends CharacterBody2D

signal toggle_inventory

@export var inventory_data: InventoryData
@export var equip_inventory_data: InventoryDataEquip
@onready var health_bar = $HealthBar

var monster_chase = false
var enemy

var monsters_defeated = false
var enemy_in_attackrange = false
var enemy_attack_cooldown = true
var walking_towards = "none"

var player_name = "Garrick Stormwind"

#player stats
var max_health = 300
var health = 300
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
@onready var http_request = $HTTPRequest
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
	walk_towards("Building3")		
	#test_http_request()		
	http_request.request_completed.connect(_on_http_request_request_comspleted)	
	send_request("Test")
	
	# set up http req object for on-chain syncs
	chain_http_req.request_completed.connect(_on_req_completed)
	self.add_child(chain_http_req) 	
	
	# do on-chain init of attributes
	update_attribute_on_chain("health", health)
	update_attribute_on_chain("attack", attack_damage)
	update_attribute_on_chain("defense", defense)
	update_attribute_on_chain("stamina", stamina)
	update_attribute_on_chain("strength", strength)
	update_attribute_on_chain("constitution", constitution)
	update_attribute_on_chain("dexterity", dexterity)
	update_attribute_on_chain("intelligence", intelligence)
	
func _physics_process(delta):
	update_healthbar()
	player_movement(delta)
	enemy_attack()
	pickup()
	current_camera()
	if walking_towards != "none" and global.current_location == global.Location.TOWN:
		walk_towards(walking_towards)
	
	if global.current_location == global.Location.DUNGEON:
		go_and_attack()
			
	if health <= 0:
		player_alive = false
		health = 0
		print("player has died")
		self.queue_free()
	
func player_movement(delta):
	
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0
		
	move_and_slide()

func play_anim(movement):
	var dir = current_direction
	var anim = $AnimatedSprite2D
	
	if dir == Direction.RIGHT:
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == Direction.LEFT:
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == Direction.UP:
		anim.flip_h = false
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("front_idle")
	if dir == Direction.DOWN:
		anim.flip_h = false
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("back_idle")


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
		#print(health)
	
func player():
	pass
	
func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func attack():
	var dir = current_direction
	
	
	global.player_current_attack = true
	attack_ip = true
	if dir == Direction.RIGHT:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("side_attack")
		$deal_attack_timer.start()
	if dir == Direction.LEFT:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("side_attack")
		$deal_attack_timer.start()
	if dir == Direction.DOWN:
		$AnimatedSprite2D.play("front_attack")
		$deal_attack_timer.start()
	if dir == Direction.UP:
		$AnimatedSprite2D.play("back_attack")
		$deal_attack_timer.start()

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
	

func heal(heal_value: int) -> void:
	health += heal_value
	update_attribute_on_chain("health", health)

func equip(stats) -> void:
	if stats["attack_damage"]:
		attack_damage += stats["attack_damage"]
		update_attribute_on_chain("attack", attack_damage)
	
	if stats["strength"]:
		strength += stats["strength"]
		update_attribute_on_chain("strength", strength)
	
	if stats["constitution"]:
		constitution += stats["constitution"]
		update_attribute_on_chain("constitution", constitution)

func unequip(stats) -> void:
	if stats["attack_damage"]:
		attack_damage -= stats["attack_damage"]
		update_attribute_on_chain("attack", attack_damage)
	
	if stats["strength"]:
		strength -= stats["strength"]
		update_attribute_on_chain("strength", strength)
	
	if stats["constitution"]:
		constitution -= stats["constitution"]
		update_attribute_on_chain("constitution", constitution)
		
func walk_towards(location_name):
	var location = locations[location_name]
	if location != null:
		var direction = location.position - position

		if current_direction == Direction.NONE:
			if abs(direction.x) > 0:
				current_direction = Direction.RIGHT if direction.x > 0 else Direction.LEFT
			else:
				current_direction = Direction.UP if direction.y > 0 else Direction.DOWN

		if current_direction == Direction.UP or current_direction == Direction.DOWN:
			if direction.y > 0:
				position.y += min(step_size, direction.y)
				if position.y >= location.position.y:
					current_direction = Direction.NONE
			else:
				position.y -= min(step_size, -direction.y)
				if position.y <= location.position.y:
					current_direction = Direction.NONE

		elif current_direction == Direction.LEFT or current_direction == Direction.RIGHT:
			if direction.x > 0:
				position.x += min(step_size, direction.x)
				if position.x >= location.position.x:
					current_direction = Direction.NONE
			else:
				position.x -= min(step_size, -direction.x)
				if position.x <= location.position.x:
					current_direction = Direction.NONE

		walking_towards = location_name
		#Call increase_dex		

func send_request(user_input: String):
	var headers = ["Content-Type: application/json"]
	#var nearby_players = self.get_parent().close_npc_list
	print("action requested")
	#function to check nearby NPCs
	var body = {
		"npc_name": self.get_parent().name,
		"npc_desc": "Test",
		"location": "park",
		"activity": current_action,
		"inventory": [],
		"message": user_input,
		"funds": 100
	}
	var body_text = JSON.stringify(body)  # use JSON.print() to convert dict to JSON string
	if user_input == "attack":
		print("moving to enemy")
		self.get_parent().start_attacking()
	
	elif user_input == "conversation":  # Add this line
		self.get_parent().start_walking_towards_npc()
	else:
		http_request.request("http://127.0.0.1:5000/chat", headers, HTTPClient.METHOD_POST, body_text)

func test_http_request():
	print("sending request")
	var url = "https://httpbin.org/get" # Replace this with your url
	http_request.request(url) # Send a GET request

func _on_http_request_request_comspleted(result, response_code, headers, body):
	print("request completed")
	print(self.name)
	print(response_code)
	#print(body)
	print(result)
		#If Nill or null just wait*
	#var json = JSON.parse_string(body.get_string_from_utf8()
	var res = str_to_var(body.get_string_from_utf8())
	if res == null:
		self.send_request("did nothing")
		return
	print("=====response")
	print(res)
	var response = JSON.parse_string(res)	
	
	#var text = response["choices"][0]["text"].strip_edges()
	print("Who?", self.get_parent().name)
	print("RESPONSE", response)
	#self.get_parent().change_panel_text(response.action.thought)
	#self.get_parent().change_emotion(response.action.feeling)
	#self.get_node("/root/world/info_box").get_node(self.get_parent().name).get_node("thought").text = response.action.thought

	if response.action.type == "walkTo":
		current_action = "walking"
		var location_name = response.action.where
		print("walking to " + location_name)
		self.walk_towards(location_name)
		self.send_request("Just walked to " + location_name)
				
	elif response.action.type == "wait":
		print("WAITING")
		self.send_request("Just Waited")
									
			
func update_healthbar():
	health_bar.value = health
	
func increase_attack_damage(amount):
	attack_damage += amount
	print("Player", self.name)
	print("attack increased to", self.attack_damage)
	update_attribute_on_chain("attack", attack_damage)

func increase_strength(amount):
	strength += amount
	print("Player", self.name)
	print("strength increased to", self.strength)	
	update_attribute_on_chain("strength", strength)	
	
func increase_health(amount):
	health += amount
	print("Player", self.name)
	print("health increased to", self.health)	
	update_attribute_on_chain("health", health)

func increase_constitution(amount):
	constitution += amount
	print("Player", self.name)
	print("constitution increased to ", self.constitution)
	update_attribute_on_chain("constitution", constitution)		


#func _on_detection_area_body_entered(body):
#	print("BODY ENTERED", body)
#	if body.is_in_group("dungeon_monsters"):
#		print("MONSTER ENTERED", body)
#		monster_chase = true
#		enemy = body
#
#func _on_detection_area_body_exited(body):
#	if body.is_in_group("dungeon_monsters"):
#		monster_chase = false
	
func go_and_attack():
	for monster in monsters:
		if is_instance_valid(monster):
			enemy = monster
			monster_chase = true
			break
			
	
	if enemy != null:
		position += (enemy.position - position)/speed
		var direction = enemy.position - position

		if current_direction == Direction.NONE:
			if abs(direction.x) > 0:
				current_direction = Direction.RIGHT if direction.x > 0 else Direction.LEFT
			else:
				current_direction = Direction.UP if direction.y > 0 else Direction.DOWN

		if current_direction == Direction.UP or current_direction == Direction.DOWN:
			if direction.y > 0:
				position.y += min(step_size, direction.y)
				if position.y >= enemy.position.y:
					current_direction = Direction.NONE
			else:
				position.y -= min(step_size, -direction.y)
				if position.y <= enemy.position.y:
					current_direction = Direction.NONE

		elif current_direction == Direction.LEFT or current_direction == Direction.RIGHT:
			if direction.x > 0:
				position.x += min(step_size, direction.x)
				if position.x >= enemy.position.x:
					current_direction = Direction.NONE
			else:
				position.x -= min(step_size, -direction.x)
				if position.x <= enemy.position.x:
					current_direction = Direction.NONE
					
		if enemy_in_attackrange and enemy.health > 0:
			attack()

func _on_req_completed(result, response_code, headers, body):
	pass

func update_attribute_on_chain(attribute, value):
	var headers = ["Content-Type: application/json"]
	var body = {
		"player": self.name,
		"attribute": attribute,
		"value": value
	}
	var body_text = JSON.stringify(body)  

	var error = chain_http_req.request("http://127.0.0.1:3000/attribute", headers, HTTPClient.METHOD_POST, body_text)
	if error != OK:
		print("An error occurred in the HTTP request")	
	else:
		print("===== On-chain update result: " + attribute + " updated for " + self.name)

