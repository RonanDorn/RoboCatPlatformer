extends Node2D
@onready var animation_player = $AnimationPlayer
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	modulate.a = 255
	collision_shape_2d.disabled = false
	animated_sprite_2d.play("default")

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		animated_sprite_2d.stop()
		GlobalEvents.coin_picked.emit()
		animation_player.play("fade_out")
		await animation_player.animation_finished
		queue_free()
