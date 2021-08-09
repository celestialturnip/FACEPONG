extends KinematicBody2D

var MainInstances = ResourceLoader.MainInstances

var ball = null
var speed = null
var velocity = Vector2.ZERO
export(int, 0, 1) var is_human

func _ready():
	ball = MainInstances.Ball
	$Sprite.modulate = Utils.get_random_color()
	speed = 250 if is_human else rand_range(250, 450)

func _process(_delta):
	if is_human:
		velocity = Vector2(
			int(Input.is_action_pressed("ui_right")) -
			int(Input.is_action_pressed("ui_left")
		), 0) * speed
		return
	# AI logic.
	if not ball: return

	# Update velocity depending on orientation.
	if int(round(rotation_degrees)) % 180 == 0:
		velocity = Vector2(position.direction_to(ball.position).x, 0) * speed
	else:
		velocity = Vector2(0, position.direction_to(ball.position).y) * speed

func _physics_process(delta):
	var _collision_info = move_and_collide(velocity * delta)
