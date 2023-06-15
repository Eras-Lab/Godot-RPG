extends Node

class_name play_anim

# Called when the node enters the scene tree for the first time.

@onready var anim = $"../AnimatedSprite2D"
enum Direction { UP, DOWN, LEFT, RIGHT, NONE }

func play_anim(current_direction, movement, attack_ip):
	var dir = current_direction
	#var anim = $AnimatedSprite2D
	
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
