extends KinematicBody2D

var MainInstances = ResourceLoader.MainInstances

var acceleration = 75
export(Color) var color
var friction = 0.30
var health = 3
var max_speed = 450
var target = null
var tracking_error = Vector2(rand_range(-2, 2), rand_range(-2, 2))
var velocity = Vector2.ZERO
export(bool) var is_human

onready var ball = MainInstances.Ball
onready var starting_position = position
onready var speed = 250 if is_human else int(rand_range(350, 450))

func _ready():
	$Sprite.modulate = color

func _process(_delta):
	if is_human:
		velocity += Vector2(
			int(Input.is_action_pressed("ui_right")) -
			int(Input.is_action_pressed("ui_left")
		), 0) * acceleration
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
		velocity.x = lerp(velocity.x, 0, friction)
		return

	# AI logic.
	if not ball: return
	target = ball.position + tracking_error

	# Update velocity depending on orientation.
	if int(round(rotation_degrees)) % 180 == 0:
		velocity = Vector2(position.direction_to(target).x, 0) * speed
	else:
		velocity = Vector2(0, position.direction_to(target).y) * speed

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if not collision_info: return
	if int(round(rotation_degrees)) % 180 == 0:
		position.y = starting_position.y
	else:
		position.x = starting_position.x
