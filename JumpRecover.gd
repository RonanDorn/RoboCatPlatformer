extends Area2D
@onready var animation_player = $AnimationPlayer


func _on_body_entered(body):
	if body.name == "Player":
		GlobalEvents.jump_recover.emit()
		animation_player.play("FadeOut")
		await animation_player.animation_finished
		animation_player.play("RESET")
