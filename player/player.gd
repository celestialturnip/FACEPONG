extends KinematicBody2D
class_name Player

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
	if Input.is_action_just_pressed("ui_cancel"):
		assert(!get_tree().change_scene("res://menus/start_menu.tscn"))
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

func on_hit():
	SoundFX.play("player_hit.wav")
	$Tween.interpolate_property(
		self, # object
		"scale", # property
		Vector2(1.3, 1.3), # initial_val
		Vector2(1.0, 1.0), # final_val
		0.3, # duration
		Tween.TRANS_BACK, # trans_type
		Tween.EASE_IN # ease_type
	)
	$Tween.start()

func on_goal_allowed():
	health -= 1
	if is_human:
		SoundFX.play("goal_allowed.wav")
	else:
		SoundFX.play("goal_scored.wav")


func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if not collision_info: return
	if int(round(rotation_degrees)) % 180 == 0:
		position.y = starting_position.y
	else:
		position.x = starting_position.x
