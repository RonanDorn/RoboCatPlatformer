extends MarginContainer

func _ready():
	var level_array : Array = DirAccess.get_files_at("res://scenes/levels/")
	GlobalEvents.create_levels_button.emit(level_array.size())
	
func _on_levels_button_pressed():
	pass # Replace with function body.

func _on_quit_button_pressed():
	get_tree().quit()


func _on_level_1_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/1_level.tscn")
func _on_level_2_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/2_level.tscn")
func _on_level_3_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/3_level.tscn")

func _on_level_8_pressed():
	get_tree().change_scene_to_file("res://scenes/test_level.tscn")


