extends StaticBody2D

var time_until_angry = 9
var state = "happy"

func _ready() -> void:
	$Timer.start(time_until_angry)

func on_hit():
	$Timer.start(time_until_angry)
	match state:
		"happy":
			if $Tween.is_active(): return
			SoundFX.play("player_hit.wav")
			$Tween.interpolate_property(self, "scale", Vector2(1.3, 1.3), Vector2(1,1), .3, Tween.TRANS_BACK, Tween.EASE_IN)
			$Tween.start()
		"angry":
			SoundFX.play("player_hit.wav")
			$Tween.interpolate_property(self, "scale", scale * 1.2, Vector2(1,1), 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			$Tween.interpolate_property(self, "modulate", Utils.colors["red"], Utils.colors["yellow"], 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			$Tween.start()
			$Sprite.frame = 0
			state = "happy"
			$Timer.start(time_until_angry)

func _on_Timer_timeout() -> void:
	become_angry()
	$Timer.start(time_until_angry)

func become_angry():
	match state:
		"happy":
			$Tween.interpolate_property(self, "scale", Vector2(1,1), Vector2(2,2), 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			$Tween.interpolate_property(self, "modulate", Utils.colors["yellow"], Utils.colors["red"], 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			$Tween.start()
			$Sprite.frame = 1
			state = "angry"
		"angry":
			$Tween.interpolate_property(self, "scale", scale, scale + Vector2(1, 1), 1, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			$Tween.start()
