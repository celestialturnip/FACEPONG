extends StaticBody2D

func on_hit():
	SoundFX.play("tree_hit.wav")
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
