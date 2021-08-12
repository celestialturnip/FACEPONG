extends Node2D

var octopus = preload("res://enemies/octopus.tscn")

onready var timer = $Timer

func get_random_spawn_point():
	return $SpawnPoints.get_children()[0 if randi() % 2 == 0 else 1].position

func _on_Timer_timeout():
	timer.wait_time = rand_range(10,11)
	timer.start()
	var current_spawn = get_node("Octopus")
	if current_spawn:
		current_spawn.fade_out()
		current_spawn = null
		return
	var instance = octopus.instance()
	instance.position = get_random_spawn_point()
	add_child(instance)
