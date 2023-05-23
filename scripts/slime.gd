extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null

var player_in_attackzone = false
var player_in_talkrange = false
var max_health = 100
var health = 100

var can_take_damage = true
@onready var health_bar = $HealthBar

func _ready():
	health_bar.max_value = max_health

func _physics_process(delta):
	deal_with_damage()
	update_healthbar()
	
	if player_chase:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("walk")
		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	player_in_talkrange = true


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false
	player_in_talkrange = false

func enemy():
	pass

func update_healthbar():
	health_bar.value = health

func _on_slime_hitbox_body_entered(body):
	if body.has_method("player"):
		player_in_attackzone = true


func _on_slime_hitbox_body_exited(body):
	if body.has_method("player"):
		player_in_attackzone = false

func deal_with_damage():
	if player_in_attackzone and global.player_current_attack == true:
		if can_take_damage == true:
			health = health - 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print("slime health = ", health)
			if health <= 0:
				self.queue_free()

func _on_take_damage_cooldown_timeout():
	can_take_damage = true
