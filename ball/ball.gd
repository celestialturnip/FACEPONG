extends KinematicBody2D

var speed = 100
var velocity = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized() * speed

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if not collision: return
	if collision:
		velocity = velocity.bounce(collision.normal)
