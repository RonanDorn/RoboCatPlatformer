extends StaticBody2D

@onready var animation_player = $AnimationPlayer

func _ready():
	GlobalEvents.plate_active.connect(block_activated)
	
func block_activated(block_name):
	if self.name == block_name:
		animation_player.play("Activated")
		await animation_player.animation_finished
		queue_free()
