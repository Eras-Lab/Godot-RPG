extends Control
@onready var animation_player = $AnimationPlayer

signal notification_finished(notification)

func _on_timer_timeout():
	animation_player.play("fade")
	animation_player.connect("animation_finished",_onFadeAnimationFinished)


func _onFadeAnimationFinished(anim_name):
	print("Animation Finished")
	emit_signal("notification_finished", self)
