extends Resource
class_name PlayerMovement

@export var speed = 200
@export var acceleration = 650
@export var friction = 1200
@export var jump_short_impulse = -100
@export var jump_impulse = -350
@export var air_acceleration = 500
@export var air_resistance = 1000
@export var terminal_gravity = 1450
@export var extra_gravity = 250
@export var blink_impulse = 700
@export var slide_speed = 400
@export var slide_acceleration = 50
@export var wall_jump_impulse = Vector2(45, -250)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
