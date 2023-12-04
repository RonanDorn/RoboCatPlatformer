extends MarginContainer
@onready var animation_player = $LevelTransition/AnimationPlayer

func _ready():
	animation_player.play("FadeOut")

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
func _on_level_5_pressed():
	pick_level(5)
func _on_level_6_pressed():
	pick_level(6)
func _on_level_7_pressed():
	pick_level(7)

func pick_level(level_name):
	animation_player.play("FadeIn")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/levels/" + str(level_name) + "_level.tscn")


