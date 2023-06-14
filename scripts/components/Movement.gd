class_name Movement

extends Node

@onready var animated_sprite_2d = $"../AnimatedSprite2D"
@onready var player = $".." # instantiating the player (character)

var current_direction
var step_size = 1

func _init():
	pass

func player_movement(delta, speed):
	var velocity = Vector2()

	if Input.is_action_pressed("ui_right"):
		current_direction = player.Direction.RIGHT
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_direction = player.Direction.LEFT
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_direction = player.Direction.DOWN
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("ui_up"):
		current_direction = player.Direction.UP
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0

	player.velocity = velocity
	player.move_and_slide() # in Godot 4, no argument needed


func play_anim(movement):
	var dir = current_direction
	var anim = animated_sprite_2d

	# similar to your original code for play_anim, but simplified
	if dir in [player.Direction.RIGHT, player.Direction.LEFT]:
		anim.flip_h = dir == player.Direction.LEFT
		anim.play("side_" + ("walk" if movement == 1 else "idle") if not player.attack_ip else anim.animation)
	elif dir == player.Direction.UP:
		anim.flip_h = false
		anim.play("front_" + ("walk" if movement == 1 else "idle") if not player.attack_ip else anim.animation)
	elif dir == player.Direction.DOWN:
		anim.flip_h = false
		anim.play("back_" + ("walk" if movement == 1 else "idle") if not player.attack_ip else anim.animation)

func walk_towards(locations, location_name):
	var location = locations[location_name]
	if location != null:
		var direction = location.position - player.position

		if current_direction == player.Direction.NONE:
			if abs(direction.x) > 0:
				current_direction = player.Direction.RIGHT if direction.x > 0 else player.Direction.LEFT
			else:
				current_direction = player.Direction.UP if direction.y > 0 else player.Direction.DOWN

		if current_direction == player.Direction.UP or current_direction == player.Direction.DOWN:
			if direction.y > 0:
				player.position.y += min(step_size, direction.y)
				if player.position.y >= location.position.y:
					current_direction = player.Direction.NONE
			else:
				player.position.y -= min(step_size, -direction.y)
				if player.position.y <= location.position.y:
					current_direction = player.Direction.NONE

		elif current_direction == player.Direction.LEFT or current_direction == player.Direction.RIGHT:
			if direction.x > 0:
				player.position.x += min(step_size, direction.x)
				if player.position.x >= location.position.x:
					current_direction = player.Direction.NONE
			else:
				player.position.x -= min(step_size, -direction.x)
				if player.position.x <= location.position.x:
					current_direction = player.Direction.NONE
