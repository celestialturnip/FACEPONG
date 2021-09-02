extends KinematicBody2D
class_name Player

var MainInstances = ResourceLoader.MainInstances

var acceleration = 75
var colour
var friction = 0.30
var health = 3
var max_speed = 450  # Human player only.
var target = null
var tracking_error = Vector2(rand_range(-6, 6), rand_range(-8, 8)) if Utils.game_difficulty == Utils.GAME_DIFFICULTY.EASY else  Vector2(rand_range(-4, 4), rand_range(-4, 4))
var velocity = Vector2.ZERO
export(bool) var is_human

onready var ball = MainInstances.Ball
onready var serving_position = $ServingPosition.global_position
onready var starting_position = position
onready var initial_scale = Vector2(1.3,1.3) if Utils.game_difficulty == Utils.GAME_DIFFICULTY.EASY else Vector2(1, 1)
onready var speed = 250 if (is_human or Utils.game_difficulty == Utils.GAME_DIFFICULTY.EASY) else 300

func _ready():
	scale = initial_scale
	$Sprite.modulate = get_colour()
	if is_human:
		MainInstances.Player = self
		add_to_group("Human")
		$Sprite.set_texture(load("res://player/face_{emotion}.png".format({"emotion": Utils.player_settings["emotion"]})))
	else:
		add_to_group("AI")
		$CollisionShape2D.shape.radius = 7
	Signals.emit("player_ready")

func get_colour():
	if is_human:
		colour = Utils.colour_dict[Utils.player_settings["colour"]]
	else:
		var existing = Utils.get_player_colours()
		var random_colour = Utils.get_random_colour()
		while existing.has(random_colour):
			random_colour = Utils.get_random_colour()
		colour = random_colour
	return colour

func _exit_tree():
	if is_human: MainInstances.Player = null

func _process(_delta):
	if is_human:
		velocity += Vector2(
			int(Input.is_action_pressed("ui_right")) -
			int(Input.is_action_pressed("ui_left")
		), 0) * acceleration
		velocity.x = clamp(velocity.x, -max_speed, max_speed)
		velocity.x = lerp(velocity.x, 0, friction)
		return

	# AI logic.
	if not ball: return
	target = ball.position + tracking_error

	# Update velocity depending on orientation.
	if int(round(rotation_degrees)) % 180 == 0:
		velocity = Vector2(position.direction_to(target).x, 0) * speed
	else:
		velocity = Vector2(0, position.direction_to(target).y) * speed

func on_hit():
	# Sometimes when the ball hits the player, a collision gets detected twice.
	# To avoid re-running this method twice, check how long ago the previous hit was.
	if $Tween.get_runtime() > 0.25: return
	if not $Tween.is_active(): SoundFX.play("player_hit.wav")
	$Tween.interpolate_property(
		self, # object
		"scale", # property
		initial_scale * 1.3, # initial_val
		initial_scale, # final_val
		0.3, # duration
		Tween.TRANS_BACK, # trans_type
		Tween.EASE_IN # ease_type
	)
	$Tween.start()

func on_goal_allowed():
	health -= 1
	Signals.emit("player_health_changed")

	if health == 0:
		if is_human: Signals.emit("player_died")
		else: Signals.emit("ai_died")
	if is_human:
		SoundFX.play("goal_allowed.wav")
	else:
		SoundFX.play("goal_scored.wav")

func increase_health():
	health += 1
	Signals.emit("player_health_changed")

func _physics_process(delta):
	var collision_info = move_and_collide(velocity * delta)
	if not collision_info: return
	if int(round(rotation_degrees)) % 180 == 0:
		position.y = starting_position.y
	else:
		position.x = starting_position.x
