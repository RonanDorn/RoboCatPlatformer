extends CharacterBody2D

enum STATE { MOVEMENT, JUMP, WALLSLIDE, DEATH }
var current_state = STATE.MOVEMENT

@onready var coyote_timer		: Timer				 = $Timers/CoyoteTimer
@onready var jump_buffer		: Timer				 = $Timers/JumpBuffer
@onready var anim				: AnimatedSprite2D	 = $AnimatedSprite2D

@onready var checkpoint			: Vector2			 = self.position

@export var speed				: int		 = 150
@export var acceleration		: int		 = 400
@export var friction			: int		 = 900
@export var jump_short_impulse	: int		 = -250
@export var jump_impulse		: int		 = -250
@export var air_acceleration	: int		 = 300
@export var air_resistance		: int		 = 700
@export var terminal_gravity	: int		 = 1200
@export var extra_gravity		: int		 = 150
@export var slide_speed			: int		 = 400
@export var slide_acceleration	: int		 = 50
@export var wall_jump_impulse	: Vector2	 = Vector2(45, -250)

var gravity						: int		 = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction					: int

var has_second_jump				: bool		 = true
var is_short_jump				: bool
var was_on_floor				: bool

func _ready():
	GlobalEvents.enter_in_hit_box.connect(hit_box)
	GlobalEvents.new_checkpoint.connect(checkpoint_update)
	
func _physics_process(delta):
	direction = Input.get_axis("left", "right")
	state_update(delta)
	
	was_on_floor = is_on_floor()
	
	move_and_slide()
	
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
	
func state_update(delta):
	match current_state:
		STATE.MOVEMENT : movement(delta)
		STATE.JUMP : jump(delta)
		STATE.WALLSLIDE : wallslide()
		STATE.DEATH : death()
		
func movement(delta):
	if is_on_floor() or coyote_timer.time_left > 0:
		
		if jump_buffer.time_left > 0 and !is_short_jump:
			velocity.y = jump_impulse
		
		has_second_jump = true
		is_short_jump = false
		
		if direction != 0:
			velocity.x = move_toward(velocity.x, speed * direction, acceleration * delta)
			anim.play("walk")
			if direction < 0:
				anim.flip_h = true
			elif direction > 0:
				anim.flip_h = false
		elif direction == 0:
			anim.play("idle")
			velocity.x = move_toward(velocity.x, 0, friction * delta)
			
		if Input.is_action_just_pressed("jump") and GameData.skills.high_jump:
			anim.play("jump")
			velocity.y = jump_impulse
			current_state = STATE.JUMP
		
		elif Input.is_action_just_pressed("jump") and !GameData.skills.high_jump:
			anim.play("jump")
			is_short_jump = true
			velocity.y = jump_short_impulse
			current_state = STATE.JUMP
			
	elif !is_on_floor() and coyote_timer.time_left == 0:
		current_state = STATE.JUMP
		
func jump(delta):
	if !is_on_floor():
		
		if Input.is_action_just_released("jump") and !is_on_floor() and velocity.y < jump_short_impulse:
			anim.play("jump")
			is_short_jump = true
			velocity.y = jump_short_impulse
			
		velocity.y += min(gravity * delta, terminal_gravity)
		
		if direction != 0:
			velocity.x = move_toward(velocity.x, speed * direction, air_acceleration * delta)
		elif direction == 0:
			velocity.x = move_toward(velocity.x, 0, air_resistance * delta)
		
		if Input.is_action_just_pressed("jump") and has_second_jump and GameData.skills.double_jump:
			anim.play("jump")
			velocity.y = jump_impulse
			has_second_jump = false
			
		elif Input.is_action_just_pressed("jump") and !has_second_jump:
			jump_buffer.start()
		
		if velocity.y > -60:
			anim.play("fall")		
		
		if velocity.y > 0:
			velocity.y += (gravity/10) * delta
		
		if velocity.y > gravity / 1.5:
			velocity.y += (gravity + extra_gravity) * delta
			
		if is_on_wall() and velocity.y > 0:
			current_state = STATE.WALLSLIDE
			
	elif is_on_floor():
		current_state = STATE.MOVEMENT

func wallslide():
	if !is_on_floor() and is_on_wall() and direction != get_wall_normal().x:
		
		anim.play("wallSlide")
		
		if get_wall_normal().x > 0:
			anim.flip_h = true
		elif get_wall_normal().x < 0:
			anim.flip_h = false
		
		velocity.x = 0
		velocity.y = move_toward(0, slide_speed, slide_acceleration)
		
		if Input.is_action_just_pressed("jump") and direction == get_wall_normal().x and GameData.wall_jump:
			velocity.x = wall_jump_impulse.x * direction
			velocity.y = wall_jump_impulse.y
			anim.play("wallJump")
			current_state = STATE.JUMP
	
	else:
		current_state = STATE.MOVEMENT
	
func death():
	velocity = Vector2.ZERO
	anim.play("death")
	await anim.animation_finished
	self.global_position = checkpoint
	current_state = STATE.MOVEMENT

func hit_box():
	if current_state != STATE.DEATH:
		current_state = STATE.DEATH

func checkpoint_update(checkpoint_position):
	if checkpoint !=checkpoint_position:
		checkpoint = checkpoint_position
		GlobalEvents.show_checkpoint_label.emit()
