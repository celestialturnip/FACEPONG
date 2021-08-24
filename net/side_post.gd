extends StaticBody2D
class_name SidePost

var multiplier = 1

func on_hit():
	# If Tween is already active, that means the post is being hit by a ball multiple times very quickly (most likely
	# by a player squeezing the ball against it). Increase the multiplier so that each time the ball keeps hitting the
	# post, the post gets larger pushing the ball and player away.
	if $Tween.is_active():
		multiplier *= 1.2
	else:
		multiplier = 1

	SoundFX.play("wall_hit.wav")

	
	$Tween.interpolate_property($ColorRect, "color", Color(Utils.colour_dict["red"]), Utils.colour_dict["lace"], 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "scale", Vector2(1.2, 1.2) * multiplier, Vector2(1.0, 1.0), 0.3, Tween.TRANS_BACK, Tween.EASE_IN_OUT)
	$Tween.start()

