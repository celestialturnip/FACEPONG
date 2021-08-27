extends StaticBody2D
class_name Octopus

onready var collider = $CollisionShape2D
onready var spawn_points = get_tree().root.get_node("Level03").get_node("SpawnPoints").get_children()

func _ready():
	position = Utils.random_choice(spawn_points).position
	collider.disabled = true
	modulate.a = 0
	$Tween.interpolate_property(
		self, # object
		"modulate:a", # property
		0, # initial_val
		1, # final_val
		1, # duration
		Tween.TRANS_LINEAR, # trans_type
		Tween.EASE_IN_OUT # ease_type
	)
	$Tween.start()

func on_hit():
	$CollisionShape2D.disabled = true
	$Sprite.visible = false
	$DeathEffect.visible = true
	$DeathEffect.modulate = Utils.get_random_colour()
	$DeathEffect.play("default")
	SoundFX.play("octopus_hit.wav")

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

func _on_Tween_tween_completed(_object, _key):
	if modulate.a == 1: collider.disabled = false

func _on_DeathEffect_animation_finished() -> void:
	queue_free()
