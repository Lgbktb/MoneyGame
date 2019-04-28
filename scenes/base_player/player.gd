extends KinematicBody2D

# Declare member variables here.
const RIGHT = 1
const LEFT = -1

const CLEAR = 0
const STOP = 0

const FLOOR = Vector2(0,-1)

export var gravity_modifier = 9.8
const GRAVITY = 100

export var jump_modifier = 3.5
export var max_jump_fade = 5
export var jump_fade_increment = .2
const JUMP_HEIGHT = -100
var is_jump = false
var jump_fade = 0

export var max_move_speed_modifier = 50
export var move_speed_acceleartion = 2.0
const MAX_MOVE_SPEED = 10
const MOVE_SPEED = 10

var on_ground = false
var move_horizontal = 0

var velocity = Vector2(0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	input()

func input():
	if Input.is_action_pressed("move_right"):
		move_horizontal = RIGHT
	elif Input.is_action_pressed("move_left"):
		move_horizontal = LEFT
	else:
		move_horizontal = STOP
	
	if Input.is_action_just_pressed("move_jump") || Input.is_action_just_pressed("move_up"):
		if on_ground:
			is_jump = true
	elif Input.is_action_just_released("move_jump") || Input.is_action_just_released("move_up"):
		is_jump = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += gravity(delta)
	
	if is_jump:
		if on_ground:
			velocity.y = JUMP_HEIGHT * jump_modifier
			jump_fade = jump_modifier
		
		else:
			velocity.y = JUMP_HEIGHT * jump_fade
			if jump_fade < max_jump_fade:
				jump_fade += jump_fade_increment
			else:
				is_jump = false
	
	if move_horizontal != STOP:
		if move_horizontal == RIGHT:
			velocity.x = min(velocity.x + (MOVE_SPEED * move_speed_acceleartion), (MAX_MOVE_SPEED * max_move_speed_modifier))
		if move_horizontal == LEFT:
			velocity.x = max(velocity.x - (MOVE_SPEED * move_speed_acceleartion), -(MAX_MOVE_SPEED * max_move_speed_modifier))
	else:
		velocity.x = lerp(velocity.x, 0, 0.2)
		
	animation()
	
	velocity = move_and_slide(velocity, FLOOR)
	
	if is_on_floor():
		on_ground = true
	else:
		on_ground = false

func animation():
	if move_horizontal > 0:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	if move_horizontal != 0:
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = move_horizontal < 0

func gravity(delta):
	return (GRAVITY * gravity_modifier) * delta