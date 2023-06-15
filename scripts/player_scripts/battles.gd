extends Node

class_name battle_status

# Declare a new signal
signal attack_enemy

@onready var player_status = $"../player_status"
@onready var attack_cooldown = $"../attack_cooldown"
@onready var animated_sprite_2d = $"../AnimatedSprite2D"
@onready var deal_attack_timer = $"../deal_attack_timer"

# Reference to the player node and monsters list
@onready var player = get_parent()
@onready var monsters_list = $"../../DungeonMonsters"
@onready var buildings_list = $"../../Buildings"

var enemy_in_attackrange = false
var enemy_attack_cooldown = true
#var enemy = null
var monster_chase = false
var speed = 100

enum Direction { UP, DOWN, LEFT, RIGHT, NONE }

var buildings
var monsters
var locations

func _ready():
	buildings = buildings_list.get_children()
	monsters = monsters_list.get_children()
	locations = {}
	
	for building in buildings:
		print(building)
		locations[building.name] = building		

func enemy_attack(enemy_damage : int):

	if enemy_in_attackrange && enemy_attack_cooldown == true:
		player_status.health = player_status.health - enemy_damage
		enemy_attack_cooldown = false
		print("Player Health: ", player_status.health)
		attack_cooldown.start()
	#print(health)
func go_and_attack(enemy):
	for monster in monsters:
		if is_instance_valid(monster):
			enemy = monster
			monster_chase = true
			break
			

	var position = player.position
	var current_direction = player.current_direction
	var step_size = player.step_size
	if enemy != null:
		player.position += (enemy.position - player.position)/speed
		var direction = enemy.position - player.position

		if current_direction == Direction.NONE:
			if abs(direction.x) > 0:
				current_direction = Direction.RIGHT if direction.x > 0 else Direction.LEFT
			else:
				current_direction = Direction.UP if direction.y > 0 else Direction.DOWN

		if current_direction == Direction.UP or current_direction == Direction.DOWN:
			if direction.y > 0:
				player.position.y += min(step_size, direction.y)
				if player.position.y >= enemy.position.y:
					current_direction = Direction.NONE
			else:
				player.position.y -= min(step_size, -direction.y)
				if player.position.y <= enemy.position.y:
					current_direction = Direction.NONE

		elif current_direction == Direction.LEFT or current_direction == Direction.RIGHT:
			if direction.x > 0:
				player.position.x += min(step_size, direction.x)
				if position.x >= enemy.position.x:
					current_direction = Direction.NONE
			else:
				player.position.x -= min(step_size, -direction.x)
				if player.position.x <= enemy.position.x:
					current_direction = Direction.NONE
					
		if enemy_in_attackrange and enemy.health > 0:
			attack()
			
func attack():
	var dir = player.current_direction


	global.player_current_attack = true
	player.attack_ip = true
	if dir == Direction.RIGHT:
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("side_attack")
		deal_attack_timer.start()
	if dir == Direction.LEFT:
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("side_attack")
		deal_attack_timer.start()
	if dir == Direction.DOWN:
		animated_sprite_2d.play("front_attack")
		deal_attack_timer.start()
	if dir == Direction.UP:
		animated_sprite_2d.play("back_attack")
		deal_attack_timer.start()		
		
func walk_towards(location_name):
	var location = locations[location_name]
	if location != null:
		var direction = location.position - player.position

		if player.current_direction == Direction.NONE:
			if abs(direction.x) > 0:
				player.current_direction = Direction.RIGHT if direction.x > 0 else Direction.LEFT
			else:
				player.current_direction = Direction.UP if direction.y > 0 else Direction.DOWN

		if player.current_direction == Direction.UP or player.current_direction == Direction.DOWN:
			if direction.y > 0:
				player.position.y += min(player.step_size, direction.y)
				if player.position.y >= location.position.y:
					player.current_direction = Direction.NONE
			else:
				player.position.y -= min(player.step_size, -direction.y)
				if player.position.y <= location.position.y:
					player.current_direction = Direction.NONE

		elif player.current_direction == Direction.LEFT or player.current_direction == Direction.RIGHT:
			if direction.x > 0:
				player.position.x += min(player.step_size, direction.x)
				if player.position.x >= location.position.x:
					player.current_direction = Direction.NONE
			else:
				player.position.x -= min(player.step_size, -direction.x)
				if player.position.x <= location.position.x:
					player.current_direction = Direction.NONE

		player.walking_towards = location_name
		#Call increase_dex			
