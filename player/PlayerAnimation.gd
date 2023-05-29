extends Node

# Note that we make the assumption that the `CharacterBody2D` is the parent of this node
# and is thus accessible via `get_parent()`. Adjust according to your specific scene tree.
var current_dir = "none"
var current_direction = Direction.NONE
var velocity = Vector2()
const speed = 100

enum Direction { UP, DOWN, LEFT, RIGHT, NONE }

func _physics_process(delta):
	player_movement(delta)
	play_anim(1)

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
		
	get_parent().move_and_slide()

func play_anim(movement):
	var dir = current_direction
	var anim = $"../AnimatedSprite2D"
	
	if dir == Direction.RIGHT:
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if get_parent().attack_ip == false:
				anim.play("side_idle")
	if dir == Direction.LEFT:
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if get_parent().attack_ip == false:
				anim.play("side_idle")
	if dir == Direction.UP:
		anim.flip_h = false
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if get_parent().attack_ip == false:
				anim.play("front_idle")
	if dir == Direction.DOWN:
		anim.flip_h = false
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if get_parent().attack_ip == false:
				anim.play("back_idle")
