extends StaticBody2D
class_name Octopus

onready var collider = $CollisionShape2D

func on_hit():
	queue_free()

func fade_out():
	collider.disabled = true
	$Tween.interpolate_property(
		self, # object
		"modulate:a", # property
		1, # initial_val
		0, # final_val
		1, # duration
		Tween.TRANS_LINEAR, # trans_type
		Tween.EASE_IN_OUT # ease_type
	)
	$Tween.start()

func _ready():
	collider.disabled = true
	modulate.a = 0
	$Tween.interpolate_property(
		self, # object
		"modulate:a", # property
		0, # initial_val
		1, # final_val
		2, # duration
		Tween.TRANS_LINEAR, # trans_type
		Tween.EASE_IN_OUT # ease_type
	)
	$Tween.start()

func _on_Tween_tween_completed(_object, _key):
	if modulate.a == 1:
		collider.disabled = false
	else:
		queue_free()
