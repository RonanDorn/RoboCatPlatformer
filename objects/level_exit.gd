extends Node2D

var next_level_path : String
@export var transition_animation: AnimationPlayer

func _ready():
	GlobalEvents.send_level_name.connect(write_next_level)
	
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		if FileAccess.file_exists(next_level_path):
			level_load(next_level_path)
		else:
			level_load("res://scenes/start_menu.tscn")

func write_next_level(level_name):
	next_level_path = "res://scenes/levels/" + str(int(level_name.left(1)) + 1) + "_level.tscn"

func level_load(next_level_path):
	get_tree().paused = true
	transition_animation.play("FadeIn")
	await transition_animation.animation_finished
	get_tree().paused == false
	get_tree().change_scene_to_file(next_level_path)
