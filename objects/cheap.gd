extends Node2D

@export var skill_to_active : String
@onready var animation_player = $AnimationPlayer

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		GlobalEvents.active_skill.emit(skill_to_active)
		animation_player.play("FadeOutCheap")
		await animation_player.animation_finished
		queue_free()
