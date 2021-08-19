extends StaticBody2D
class_name MiddlePost

func disable():
	visible = false
	$CollisionShape2D.set_deferred("disabled", true)

func enable():
	visible = true
	$CollisionShape2D.set_deferred("disabled", false)

func on_hit():
	SoundFX.play("wall_hit.wav")

	$Tween.interpolate_property($ColorRect, "color", Utils.colors["red"], Utils.colors["white"], 0.3, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "scale", Vector2(1.2, 1.2), Vector2(1.0, 1.0), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	$Tween.start()
