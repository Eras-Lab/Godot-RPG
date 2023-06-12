class_name Attack

extends Node

@onready var animated_sprite_2d = $"../AnimatedSprite2D"
@onready var deal_attack_timer = $"../deal_attack_timer"
@onready var player = $".." # instantiating the player (character)

# Flag to ensure 'attack' signal from parent node is connected only once
# so it prevents unnecessary checks in each _process cycle
var is_connected = false

func _init():
	pass

func _process(delta):
	if not is_connected:
		var parent = get_parent()
		if parent != null:
			parent.connect("go_and_attack", Callable(self, "_on_parent_attack")) # connect signal
			is_connected = true
			set_process(false)  # disable _process() once the connection is made

func attack(direction):
	global.player_current_attack = true
	player.attack_ip = true
	if direction == player.Direction.RIGHT:
		printerr("Direction Right being called")
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("side_attack")
		deal_attack_timer.start()
	elif direction == player.Direction.LEFT:
		printerr("Direction Left being called")
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("side_attack")
		deal_attack_timer.start()
	elif direction == player.Direction.DOWN:
		printerr("Direction Down being called")
		animated_sprite_2d.play("front_attack")
		deal_attack_timer.start()
	elif direction == player.Direction.UP:
		printerr("Direction Up being called")
		animated_sprite_2d.play("back_attack")
		deal_attack_timer.start()

func go_and_attack(current_direction):
	for monster in player.monsters:
		if is_instance_valid(monster):
			player.enemy = monster
			player.monster_chase = true
			break
	
	if player.enemy != null:
		player.position += (player.enemy.position - player.position)/ player.speed
		var direction = player.enemy.position - player.position

		if current_direction == player.Direction.NONE:
			if abs(direction.x) > 0:
				current_direction = player.Direction.RIGHT if direction.x > 0 else player.Direction.LEFT
			else:
				current_direction = player.Direction.UP if direction.y > 0 else player.Direction.DOWN

		if current_direction == player.Direction.UP or current_direction == player.Direction.DOWN:
			if direction.y > 0:
				player.position.y += min(player.step_size, direction.y)
				if player.position.y >= player.enemy.position.y:
					current_direction = player.Direction.NONE
			else:
				player.position.y -= min(player.step_size, -direction.y)
				if player.position.y <= player.enemy.position.y:
					current_direction = player.Direction.NONE

		elif current_direction == player.Direction.LEFT or current_direction == player.Direction.RIGHT:
			if direction.x > 0:
				player.position.x += min(player.step_size, direction.x)
				if player.position.x >= player.enemy.position.x:
					current_direction = player.Direction.NONE
			else:
				player.position.x -= min(player.step_size, -direction.x)
				if player.position.x <= player.enemy.position.x:
					current_direction = player.Direction.NONE
					
		if player.enemy_in_attackrange and player.enemy.health > 0:
			attack(current_direction)

func _on_parent_attack(direction):
	go_and_attack(direction)
