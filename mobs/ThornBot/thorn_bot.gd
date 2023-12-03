extends BoxBot


func _on_right_body_entered(_body):
	direction = 1
	speed *= 4.5

func _on_left_body_entered(_body):
	direction = -1
	speed *= 4.5

func _on_right_body_exited(_body):
	speed = 1250

func _on_left_body_exited(_body):
	speed = 1250
