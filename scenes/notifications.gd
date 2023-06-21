extends Control
@onready var animation_player = $AnimationPlayer

func _on_timer_timeout():
	animation_player.play("fade")
	animation_player.connect("animation_finished",_onFadeAnimationFinished)


func _onFadeAnimationFinished(anim_name):
	queue_free()
