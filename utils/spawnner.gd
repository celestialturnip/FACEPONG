extends Node

export(PackedScene) var scene_file
export(int) var spawn_interval = 10
export(int) var max_spawn_count = 1
onready var enemy_scene = load(scene_file.resource_path)

func _ready():
	$Timer.start(spawn_interval)

func spawn():
	$Spawns.add_child(enemy_scene.instance())

func _on_Timer_timeout():
	if $Spawns.get_child_count() < max_spawn_count:
		spawn()
	$Timer.start(spawn_interval)
