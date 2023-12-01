extends Node2D
@export var animation_player: AnimationPlayer
var level_count = self.name.left(1)

func _ready():
	get_tree().paused = false
	animation_player.play("FadeOut")
	GlobalEvents.send_level_name.emit(self.name)
	RenderingServer.set_default_clear_color(Color.BLACK)
	if int(self.name.left(1)) > 2:
		print(level_count)
		GlobalEvents.active_skill.emit("high_jump")
	if int(self.name.left(1)) > 4:
		GlobalEvents.active_skill.emit("double_jump")
	if int(self.name.left(1)) > 6:
		GlobalEvents.active_skill.emit("wall_jump")
