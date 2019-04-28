extends KinematicBody2D

# Declare member variables here. Examples:
const RIGHT = 1
const LEFT = -1

const CLEAR = 0
const STOP = 0

const FLOOR = Vector2(0,-1)

export var gravity_modifier = 9.8
const GRAVITY = 100

export var jump_modifier = 10.0
const JUMP_HEIGHT = -100
var is_jump = false

export var move_speed_modifier = 5.0
const MOVE_SPEED = 100

var on_ground = false
var move_horizontal = 0

var velocity = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	input()

func input():
	if Input.is_action_pressed("move_right"):
		move_horizontal = RIGHT
		
	if Input.is_action_pressed("move_left"):
		move_horizontal = LEFT
	
	if Input.is_action_just_pressed("move_jump"):
		is_jump = true
	elif Input.is_action_just_released("move_jump"):
		is_jump = false

func clear_movement():
	move_horizontal = CLEAR
	velocity.x = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += gravity(delta)
	
	if on_ground:
		if is_jump:
			velocity.y = JUMP_HEIGHT * jump_modifier
	
	if move_horizontal != STOP:
		velocity.x = move_horizontal * (MOVE_SPEED * move_speed_modifier)
	
	animation(velocity)
	
	velocity = move_and_slide(velocity, FLOOR)

	clear_movement()
	
	if is_on_floor():
		on_ground = true
	else:
		on_ground = false

func animation(velocity):
	if velocity.length() > 0:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	if velocity.x != 0:
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0

func gravity(delta):
	return (GRAVITY * gravity_modifier) * delta