extends KinematicBody2D
class_name Ball

var MainInstances = ResourceLoader.MainInstances

var last_touch = null
var max_acceleration = 1.06
var max_speed = 140 if Utils.game_difficulty == Utils.GAME_DIFFICULTY.EASY else 180
var server = null
var speed = 70 if Utils.game_difficulty == Utils.GAME_DIFFICULTY.EASY else 130
var velocity = Vector2.ZERO

func _ready():
	MainInstances.Ball = self
	# warning-ignore:return_value_discarded
	Signals.connect("player_ready", self, "_on_player_ready")

func _on_player_ready():
	if MainInstances.Player:
		server = MainInstances.Player
		position = server.serving_position

func _exit_tree():
	MainInstances.Ball = null

func _process(_delta):
	if Input.is_action_just_pressed("serve") and (not velocity):
		serve()

func serve():
	var random_player = Utils.get_random_player(server)
	var serve_direction = server.position.direction_to(random_player.position)
	# Add some variation to avoid AIs doing a complete straight serve to the other AI.
	serve_direction += Vector2(rand_range(-0.2, 0.2), rand_range(-0.2, 0.2))
	serve_direction.normalized()
	velocity = serve_direction * speed

func reset():
	position = server.serving_position
	velocity = Vector2.ZERO
	last_touch = null

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if not collision: return

	if collision.collider.has_method("on_hit"): collision.collider.on_hit()
	if collision.collider is Player: last_touch = collision.collider

	velocity = velocity.bounce(collision.normal)
	if sqrt(pow(velocity.x, 2) + pow(velocity.y, 2)) < max_speed:
		velocity.x *= rand_range(1, max_acceleration)
		velocity.y *= rand_range(1, max_acceleration)
