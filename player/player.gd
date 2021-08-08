extends KinematicBody2D

var speed = 150
var velocity = Vector2.ZERO

func _process(delta):
	velocity = Vector2(
		int(Input.is_action_pressed("ui_right")) -
		int(Input.is_action_pressed("ui_left")
	), 0) * speed

func _physics_process(delta):
	var _collision_info = move_and_collide(velocity * delta)
