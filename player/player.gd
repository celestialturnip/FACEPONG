extends KinematicBody2D

var MainInstances = ResourceLoader.MainInstances

var ball = null
var speed = 200
var velocity = Vector2.ZERO
export(int, 0, 1) var is_human

func _ready():
	ball = MainInstances.Ball

func _process(delta):
	if is_human:
		velocity = Vector2(
			int(Input.is_action_pressed("ui_right")) -
			int(Input.is_action_pressed("ui_left")
		), 0) * speed
		return
	elif !is_human and ball:
		velocity = Vector2(position.direction_to(ball.position).x, 0) * speed
		return

func _physics_process(delta):
	var _collision_info = move_and_collide(velocity * delta)
