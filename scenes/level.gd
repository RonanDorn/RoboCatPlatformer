extends Node2D

func _ready():
	GlobalEvents.send_level_name.emit(self.name)
	RenderingServer.set_default_clear_color(Color.BLACK)
