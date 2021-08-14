extends KinematicBody2D
class_name Ball

var MainInstances = ResourceLoader.MainInstances

var max_acceleration = 1.06
var speed = 90
var velocity = Vector2.ZERO

func _ready():
	MainInstances.Ball = self
	reset()

func _exit_tree():
	MainInstances.Ball = null

func _process(_delta):
	if Input.is_action_just_pressed("reset"): reset()
	if Input.is_action_just_pressed("serve"): serve()

func serve():
	velocity = Vector2(rand_range(-0.3, .3), rand_range(-1, 1)).normalized() * speed

func reset_position():
	position = Vector2(Utils.virtual_width / 2, Utils.virtual_height / 2)

func reset():
	reset_position()
	velocity = Vector2.ZERO

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if not collision: return

	collision.collider.on_hit()

	velocity = velocity.bounce(collision.normal)
	velocity.x *= rand_range(1, max_acceleration)
	velocity.y *= rand_range(1, max_acceleration)
