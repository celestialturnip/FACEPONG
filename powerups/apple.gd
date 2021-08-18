extends Area2D

func _on_Apple_body_entered(body):
	if !(body is Ball):
		print("A non-Ball body entered the powerup which should never happen:", body)
		return
	
	var player = body.last_touch
	if not player: return
	
	SoundFX.play("powerup_pickup.wav", 1, -10)
	player.increase_health()
	queue_free()
