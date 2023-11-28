extends Node2D

@export var skill_to_active : String

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		GlobalEvents.active_skill.emit(skill_to_active)
		queue_free()
