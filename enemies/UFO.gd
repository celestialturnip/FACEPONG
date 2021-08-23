extends KinematicBody2D

var target
var speed = 40
var velocity

func _ready():
	target = pick_target()
	position = Vector2(Utils.virtual_width - target.x, Utils.virtual_height - target.y)
	velocity = position.direction_to(target) * speed
	SoundFX.play("ufo_on_ready.wav")

func _physics_process(delta):
	var _collision_info = move_and_collide(velocity * delta)

func on_hit():
	SoundFX.play("ufo_hit.wav")
	$Tween.interpolate_property(
		self, # object
		"scale", # property
		Vector2(1.2, 1.2), # initial_val
		Vector2(1.0, 1.0), # final_val
		0.2, # duration
		Tween.TRANS_BACK, # trans_type
		Tween.EASE_IN # ease_type
	)
	$Tween.start()

# target is a random point on one of the screen axis.
func pick_target():
	if randi() % 2 == 0:
		return Vector2(
			rand_range(0, Utils.virtual_width),
			0 if randi () % 2 else Utils.virtual_height
		)
	return Vector2(0 if randi () % 2 else Utils.virtual_width, rand_range(0, Utils.virtual_height))

func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	queue_free()
