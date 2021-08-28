extends KinematicBody2D
class_name Ball

var MainInstances = ResourceLoader.MainInstances

var last_touch = null
var max_acceleration = 1.05
var max_speed = 120 if Utils.game_difficulty == Utils.GAME_DIFFICULTY.EASY else 140
var server = null
var speed = 100 if Utils.game_difficulty == Utils.GAME_DIFFICULTY.EASY else 120
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
	if Input.is_action_just_pressed("serve") and (not velocity) and (get_tree().get_nodes_in_group("Player").size() > 1):
		Signals.emit("ball_served")
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
	if sqrt(pow(velocity.x, 2) + pow(velocity.y, 2)) > max_speed:
		velocity /= max_acceleration

	if collision.collider.has_method("on_hit"): collision.collider.on_hit()
	if collision.collider is Player:
		last_touch = collision.collider
		if last_touch.is_human: Utils.level_stats["touches"] += 1
	if collision.collider is Ghost:
		if not velocity: return
		var random_push = rand_range(-20, 20)
		if randi() % 2 == 0:
			velocity += Vector2(random_push, 0)
		else:
			velocity += Vector2(0, random_push)
		return

	velocity = velocity.bounce(collision.normal)
	velocity.x *= rand_range(1, max_acceleration)
	velocity.y *= rand_range(1, max_acceleration)
	
	var random_push = rand_range(-5, 5)
	velocity += Vector2(random_push, -random_push)
