extends KinematicBody2D

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
	$Sprite.modulate = Color(Utils.car_palette[randi() % len(Utils.car_palette)])
	target = trip["finish"]
	position = trip["start"]
	scale.x = trip["scale"]
	rotation_degrees = trip["rotation"]
	velocity = position.direction_to(target) * speed

func _physics_process(delta):
	if not velocity: return
	
	# Check if it would return collision.
	var collision_info = move_and_collide(velocity * delta, true, true, false)
	# If not, actually move.
	if not collision_info:
		collision_info = move_and_collide(velocity * delta)

func on_hit():
	SoundFX.play("car_hit.wav")
	if $Tween.is_active(): return
	$Tween.interpolate_property(self, "scale", scale * 1.2, scale, 0.2, Tween.TRANS_BACK, Tween.EASE_IN)
	$Tween.start()

func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	queue_free()
