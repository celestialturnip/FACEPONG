extends KinematicBody2D
class_name Ball

var MainInstances = ResourceLoader.MainInstances

var speed = 110
var velocity = Vector2.ZERO

func _ready():
	MainInstances.Ball = self
	set_velocity()

func _exit_tree():
	MainInstances.Ball = null

func _process(_delta):
	if Input.is_action_just_pressed("reset"):
		position = Vector2(Utils.virtual_width / 2, Utils.virtual_height / 2)
		set_velocity()

func set_velocity():
	velocity = Vector2(rand_range(-0.3, .3), rand_range(-1, 1)).normalized() * speed

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if not collision: return
	if collision:
		velocity = velocity.bounce(collision.normal)
