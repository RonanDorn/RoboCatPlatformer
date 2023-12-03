extends MarginContainer
@onready var animation_player = $LevelTransition/AnimationPlayer

func _ready():
	var level_array : Array = DirAccess.get_files_at("res://scenes/levels/")
	GlobalEvents.create_levels_button.emit(level_array.size())

func _on_quit_button_pressed():
	get_tree().quit()


func _on_level_1_pressed():
	pick_level(1)
func _on_level_2_pressed():
	pick_level(2)
func _on_level_3_pressed():
	pick_level(3)
func _on_level_4_pressed():
	pick_level(4)

func pick_level(level_name):
	animation_player.play("FadeIn")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/levels/" + str(level_name) + "_level.tscn")

