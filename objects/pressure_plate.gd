extends Node2D

@export var linked_object	: StaticBody2D
@onready var animation_player = $AnimationPlayer

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		GlobalEvents.plate_active.emit(linked_object.name)
		animation_player.play("Activated")
