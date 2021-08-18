extends Node

export(int) var max_spawn_interval = 10
onready var apple = preload("res://powerups/apple.tscn")

func _ready():
	$Timer.start(rand_range(1, max_spawn_interval))

func get_random_position():
	return Vector2(
		rand_range(Utils.virtual_width / 4, 3 * Utils.virtual_width / 4),
		rand_range(Utils.virtual_height / 4, 3 * Utils.virtual_height / 4)
	)

func spawn():
	var instance = apple.instance()
	instance.position = get_random_position()
	add_child(instance)

func _on_Timer_timeout():
	spawn()
	$Timer.start(rand_range(1, max_spawn_interval))
