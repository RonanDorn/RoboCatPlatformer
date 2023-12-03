extends CharacterBody2D

@onready var animated_sprite_2d : AnimatedSprite2D		 = $AnimatedSprite2D
@onready var jump_timer			: Timer					 = $JumpTimer
@onready var collision_shape_2d : CollisionShape2D		 = $HitBox/CollisionShape2D
@onready var animation_player	: AnimationPlayer		 = $AnimationPlayer

@export var speed			 : int	 = 100
@export var jump_impulse	 : int	 = -200
@export var gravity			 : int	 = 750
@export var direction		 : int	 = 1

func _physics_process(delta):
	change_direction()
	if is_on_floor():
		animated_sprite_2d.play("idle")
		velocity.x = 0
	elif !is_on_floor():
		animated_sprite_2d.play("jump")
		velocity.x = speed * direction + delta
	jump()
	apply_gravity(delta)
		
	move_and_slide()
	
func change_direction():
	if is_on_wall():
		direction *= -1
		
	if direction > 1:
		animated_sprite_2d.flip_h = false
	elif direction < 1:
		animated_sprite_2d.flip_h = true

func jump():
	if is_on_floor() and jump_timer.time_left == 0:
		velocity.y = jump_impulse
		jump_timer.start()
		
func apply_gravity(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
