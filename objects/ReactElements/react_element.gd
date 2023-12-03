extends Node
class_name ReactElement

var animated_sprite_2d
var animation_player

var current_state : String
		
func _change_state(state : String):
	animation_player.play(state)
	animated_sprite_2d.play(state)
	await animation_player.animation_finished
	current_state = state
