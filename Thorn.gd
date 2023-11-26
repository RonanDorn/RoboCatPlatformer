extends Area2D

signal death

func _on_body_entered(body):
	if body == "Player":
		emit_signal
