extends CharacterBody2D
class_name BoxBot

@onready var anim				: AnimatedSprite2D	 = $AnimatedSprite2D
@onready var right_ledge		: RayCast2D			 = $RightLedge
@onready var left_ledge			: RayCast2D			 = $LeftLedge
@onready var animated_sprite_2d :AnimatedSprite2D	 = $AnimatedSprite2D

var speed		 : int = 750
var direction	 : int = 1

func _physics_process(delta):
	if !right_ledge.is_colliding() or !left_ledge.is_colliding() or self.is_on_wall():
		change_direction()
		
	if direction > 0:
		anim.flip_h = false
	elif direction < 0:
		anim.flip_h = true
	
	movement(delta)
	
	move_and_slide()
	
func movement(delta):
	velocity.x = speed * direction * delta	
	anim.play("walk")

func change_direction():
	direction *= -1
	velocity.x += 600 *direction
