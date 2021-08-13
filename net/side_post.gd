extends StaticBody2D
class_name SidePost


func on_hit():
	SoundFX.play("wall_hit.wav")
	$Tween.interpolate_property(
		$ColorRect, # object
		"color", # property
		Color.white, # initial_val
		Color.red, # final_val
		0.05, # duration
		Tween.TRANS_LINEAR, # trans_type
		Tween.EASE_IN_OUT # ease_type
	)
	$Tween.start()

func _on_Tween_tween_completed(object, key):
	if $ColorRect.color == Color.white:
		return

	$Tween.interpolate_property(
		$ColorRect, # object
		"color", # property
		Color.red, # initial_val
		Color.white, # final_val
		0.05, # duration
		Tween.TRANS_LINEAR, # trans_type
		Tween.EASE_IN_OUT # ease_type
	)
	$Tween.start()
