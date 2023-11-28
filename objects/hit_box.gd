extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		GlobalEvents.enter_in_hit_box.emit()
