extends ReactElement

func _ready():
	animated_sprite_2d = $AnimatedSprite2D
	animation_player = $AnimationPlayer
	GlobalEvents.player_jump.connect(switch)
	current_state = "off"
	
func switch():
	if current_state == "off":
		_change_state("on")
	elif current_state == "on":
		_change_state("off")
