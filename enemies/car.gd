extends KinematicBody2D

var last_movement_time = OS.get_unix_time()
var speed = 30
var target
var velocity

var top = Vector2(Utils.virtual_width / 2, 0)
var left = Vector2(0, Utils.virtual_height / 2)
var bottom = Vector2(Utils.virtual_width / 2, Utils.virtual_height)
var right = Vector2(Utils.virtual_width, Utils.virtual_height / 2)

var map = {
	"north_to_south": {"start": top + Vector2(12, 0), "finish": bottom + Vector2(12,0), "rotation": 90, "scale": 1},
	"east_to_west": {"start": right + Vector2(0, 8), "finish": left + Vector2(0, 8), "scale": -1, "rotation": 0},
	"south_to_north": {"start": bottom + Vector2(-12, 0), "finish": top + Vector2(-12, 0), "scale": 1, "rotation": -90},
	"west_to_east": {"start": left + Vector2(0, -12), "finish": right + Vector2(0, -12), "scale": 1, "rotation": 0}
}
var trip = map[map.keys()[randi() % 4]]

func _ready():
	$Sprite.modulate = Utils.get_random_colour()
	target = trip["finish"]
	position = trip["start"]
	scale.x = trip["scale"]
	rotation_degrees = trip["rotation"]
	velocity = position.direction_to(target) * speed

func _physics_process(delta):
	if not velocity: return
	
	# Check if it would return collision.
	var collision_info = move_and_collide(velocity * delta, true, true, false)
	
	# If so, check if timer paused already - if not, start it.
	if collision_info:
		if (OS.get_unix_time() - last_movement_time) > 1:
			_on_Timer_timeout()
			last_movement_time = OS.get_unix_time()

	# If no collision, actually move.
	else:
		collision_info = move_and_collide(velocity * delta)
		last_movement_time = OS.get_unix_time()
		

func on_hit():
	if not $Tween.is_active(): SoundFX.play("car_hit.wav")
	$Tween.interpolate_property(self, "scale", scale * 1.2, scale, 0.2, Tween.TRANS_BACK, Tween.EASE_IN)
	$Tween.start()

func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	queue_free()

func _on_Timer_timeout() -> void:
	$DeathEffect.play("default")
	$Sprite.visible = false
	$DeathEffect.visible = true
	$DeathEffect.modulate = $Sprite.modulate
	$DeathEffect.play("default")
	SoundFX.play("car_explosion.wav")

func _on_DeathEffect_animation_finished() -> void:
	queue_free()
