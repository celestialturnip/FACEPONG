extends KinematicBody2D
class_name Ball

var MainInstances = ResourceLoader.MainInstances

var speed = 150
var velocity = Vector2(rand_range(-0.3, .3), rand_range(-1, 1)).normalized() * speed

func _ready():
	MainInstances.Ball = self

func _exit_tree():
	MainInstances.Ball = null

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if not collision: return
	if collision:
		velocity = velocity.bounce(collision.normal)
