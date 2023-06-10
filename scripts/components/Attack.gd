class_name Attack

extends Node

enum Direction { UP, DOWN, LEFT, RIGHT }

@onready var animated_sprite_2d = $"../AnimatedSprite2D"
@onready var deal_attack_timer = $"../deal_attack_timer"

var is_connected = false

func _init():
	pass

func _process(delta):
	if not is_connected:
		var parent = get_parent()
		if parent != null:
			parent.connect("attack", Callable(self, "_on_parent_attack")) # connect signal
			is_connected = true
			set_process(false)  # disable _process() once the connection is made

func attack(direction):
	global.player_current_attack = true
	if direction == Direction.RIGHT:
		printerr("Direction Right being called")
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("side_attack")
		deal_attack_timer.start()
	elif direction == Direction.LEFT:
		printerr("Direction Left being called")
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("side_attack")
		deal_attack_timer.start()
	elif direction == Direction.DOWN:
		printerr("Direction Down being called")
		animated_sprite_2d.play("front_attack")
		deal_attack_timer.start()
	elif direction == Direction.UP:
		printerr("Direction Up being called")
		animated_sprite_2d.play("back_attack")
		deal_attack_timer.start()

func _on_parent_attack(direction):
	attack(direction)
