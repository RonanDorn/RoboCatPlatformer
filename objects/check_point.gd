extends Node2D

func _on_area_2d_body_entered(body):
	GlobalEvents.new_checkpoint.emit(self.position)
	print("123")
