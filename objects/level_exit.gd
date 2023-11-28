extends Node2D

var next_level_path : String

func _ready():
	GlobalEvents.send_level_name.connect(write_next_level)
	
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		if FileAccess.file_exists(next_level_path):
			get_tree().change_scene_to_file(next_level_path)
		else:
			return

func write_next_level(level_name):
	next_level_path = "res://scenes/levels/" + str(int(level_name.left(1)) + 1) + "_level.tscn"
