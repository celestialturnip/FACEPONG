extends KinematicBody2D

var MainInstances = ResourceLoader.MainInstances

var velocity = Vector2.ZERO
export(bool) var is_human

onready var ball = MainInstances.Ball
onready var starting_position = position
onready var speed = 250 if is_human else int(rand_range(250, 450))

func _ready():
	$Sprite.modulate = Utils.get_random_color()

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
	var collision_info = move_and_collide(velocity * delta)
	if not collision_info: return
	if int(round(rotation_degrees)) % 180 == 0:
		position.y = starting_position.y
	else:
		position.x = starting_position.x
