extends Area2D

@onready var timer = $Timer

var players_in_area = []

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _on_body_entered(body):
	if body.name.begins_with("player"):
		print("player ", body.name)
		print("entered area 2d")      
		players_in_area.append(body)
		if len(players_in_area) == 1: # If this is the first player, start the timer.
			timer.start()

func _on_body_exited(body):
	if body in players_in_area:
		players_in_area.erase(body)
		if len(players_in_area) == 0: # If there are no more players, stop the timer.
			timer.stop()

func _on_timer_timeout():
	for player in players_in_area:
		player.increase_health(10)
