extends CharacterBody2D

enum STATE { MOVEMENT, FALL, WALLSLIDE, DEATH }
var current_state = STATE.MOVEMENT

@onready var coyote_timer			: Timer				 = $Timers/CoyoteTimer
@onready var jump_buffer			: Timer				 = $Timers/JumpBuffer
@onready var jump_timer				: Timer				 = $Timers/JumpTimer
@onready var notification_timer		: Timer				 = $Timers/NotificationTimer
@onready var portal_immune_timer	: Timer				 = $Timers/PortalImmuneTimer
@onready var anim					: AnimatedSprite2D	 = $AnimatedSprite2D

@onready var checkpoint				: Vector2			 = self.position

@export var speed					: int				 = 145
@export var acceleration			: int				 = 285
@export var friction				: int				 = 750
@export var jump_impulse			: int				 = -155
@export var jump_cut_impulse		: int				 = -60
@export var high_jump_impulse		: int				 = -270
@export var air_acceleration		: int				 = 250
@export var air_resistance			: int				 = 450
@export var terminal_gravity		: int				 = 250
@export var extra_gravity			: int				 = 50
@export var slide_speed				: int				 = 400
@export var slide_acceleration		: int				 = 50
@export var wall_jump_impulse		: Vector2			 = Vector2(45, -250)

var gravity						: int					 = 785
var direction					: int

var has_second_jump				: bool					 = true
var is_cut_jump					: bool
var was_on_floor				: bool
var is_jumping					: bool


func _ready():
	GlobalEvents.enter_in_hit_box.connect(hit_box)
	GlobalEvents.new_checkpoint.connect(checkpoint_update)
	GlobalEvents.send_portal_coord.connect(portal_to)
	
func _physics_process(delta):
	direction = Input.get_axis("left", "right")
	state_update(delta)
	
	was_on_floor = is_on_floor()

	move_and_slide()
	
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
	
func state_update(delta):
	match current_state:
		STATE.MOVEMENT : movement_state(delta)
		STATE.FALL : fall_state(delta)
		STATE.WALLSLIDE : wallslide_state()
		STATE.DEATH : death_state()
		
func movement_state(delta):
	if is_on_floor() or coyote_timer.time_left > 0:
		
		is_jumping = false
		has_second_jump = true
		is_cut_jump = false
		
		if jump_buffer.time_left > 0 and !is_cut_jump:
			velocity.y = jump_impulse
		
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
			
		want_to_jump(delta)
			
	elif !is_on_floor() and coyote_timer.time_left == 0:
		current_state = STATE.FALL
		
func fall_state(delta):
	if !is_on_floor():
		
		if Input.is_action_just_released("jump") and !is_on_floor() and velocity.y < jump_cut_impulse:
			cut_jump(delta)
		
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
			
		apply_gravity(delta)
			
		if is_on_wall() and velocity.y > 0:
			current_state = STATE.WALLSLIDE
			
	elif is_on_floor():
		current_state = STATE.MOVEMENT

func wallslide_state():
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
			current_state = STATE.FALL
	
	else:
		current_state = STATE.MOVEMENT
	
func death_state():
	velocity = Vector2.ZERO
	anim.play("death")
	await anim.animation_finished
	self.global_position = checkpoint
	current_state = STATE.MOVEMENT

func want_to_jump(delta):
	
	if Input.is_action_just_pressed("jump"):
		if GameData.skills.high_jump and Input.is_action_pressed("s"):
			high_jump(delta)
		elif Input.is_action_just_pressed("jump"):
			jump(delta)
		else :
			cut_jump(delta)
	if Input.is_action_just_released("jump"):
		cut_jump(delta)
		
func high_jump(delta):
	anim.play("jump")
	is_jumping = true
	velocity.y += high_jump_impulse
	
func jump(delta):
	anim.play("jump")
	is_jumping = true
	velocity.y += jump_impulse
	
func cut_jump(delta):
	anim.play("jump")
	is_cut_jump = true
	velocity.y = jump_cut_impulse
	
func apply_gravity(delta):
	gravity_func(gravity, delta)
	
	if velocity.y > - 120:
		gravity_func(gravity * 0.05, delta)
		
	if velocity.y > -100:
		gravity_func(gravity * 0.03, delta)
	
	if velocity.y > -90:
		gravity_func(gravity * 0.02, delta)
		
	if velocity.y > -80:
		gravity_func(gravity * 0.01, delta)
		
	if velocity.y > 0:
		gravity_func(gravity * 0.02, delta)
		
	if velocity.y > 10:
		gravity_func(gravity * 0.03, delta)
		
	if velocity.y > 20:
		gravity_func(gravity * 0.05, delta)
		
	if velocity.y > 80:
		gravity_func(gravity * 0.08, delta)
		
func gravity_func(gravity_num, delta):
	velocity.y += min(gravity_num * delta, terminal_gravity)

func hit_box():
	if current_state != STATE.DEATH:
		current_state = STATE.DEATH

func checkpoint_update(checkpoint_position):
	if checkpoint !=checkpoint_position:
		checkpoint = checkpoint_position
		GlobalEvents.show_checkpoint_label.emit()

func portal_to(linked_portal_coordinate):
	if portal_immune_timer.time_left == 0:
		print("immune_timer")
		self.position = linked_portal_coordinate
		portal_immune_timer.start()
