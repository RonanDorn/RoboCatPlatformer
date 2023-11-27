extends Node2D

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		GlobalEvents.coin_picked.emit()
		queue_free()
