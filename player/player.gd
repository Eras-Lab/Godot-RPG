extends CharacterBody2D

signal toggle_inventory

@export var inventory_data: InventoryData
@export var equip_inventory_data: InventoryDataEquip

var enemy_in_attackrange = false
var enemy_attack_cooldown = true

#player stats
var health = 160
var strength = 10
var constitution = 10
var attack_damage = 10

var player_alive = true

var attack_ip = false

const speed = 100
var current_dir = "none"

func _ready():
	PlayerManager.player = self
	$AnimatedSprite2D.play("front_idle")
	
func _physics_process(delta):
	player_movement(delta)
	enemy_attack()
	attack()
	pickup()
	current_camera()
	
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
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "down":
		anim.flip_h = false
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("front_idle")
	if dir == "up":
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
		print(health)
	
func player():
	pass
	
func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true

func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()
		if dir == "up":
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

func equip(stats) -> void:
	if stats["attack_damage"]:
		attack_damage += stats["attack_damage"]
	
	if stats["strength"]:
		strength += stats["strength"]
	
	if stats["constitution"]:
		constitution += stats["constitution"]

func unequip(stats) -> void:
	if stats["attack_damage"]:
		attack_damage -= stats["attack_damage"]
	
	if stats["strength"]:
		strength -= stats["strength"]
	
	if stats["constitution"]:
		constitution -= stats["constitution"]
