extends KinematicBody2D

var MainInstances = ResourceLoader.MainInstances
var acceleration = rand_range(15, 30)
var friction = rand_range(0.1, 0.5)
var max_speed = rand_range(15, 30)
var velocity = Vector2.ZERO

onready var ball = MainInstances.Ball
onready var collider = $CollisionShape2D
onready var target = ball.position

func _ready():
	collider.disabled = true
	modulate.a = 0
	position = Vector2(
		rand_range(0, Utils.virtual_width),
		rand_range(0, Utils.virtual_height)
	)
	$Tween.interpolate_property(
		self, # object
		"modulate:a", # property
		0, # initial_val
		1, # final_val
		2, # duration
		Tween.TRANS_LINEAR, # trans_type
		Tween.EASE_IN_OUT # ease_type
	)
	$Tween.start()

func _physics_process(delta):
	velocity = position.direction_to(target) * acceleration
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
	velocity.x = lerp(velocity.x, 0, friction)
	velocity.y = lerp(velocity.y, 0, friction)
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		queue_free()

func _on_Timer_timeout():
	target = ball.position

func _on_Tween_tween_completed(object, key):
	collider.disabled = false
