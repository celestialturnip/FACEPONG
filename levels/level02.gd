extends Node2D

var ghost = preload("res://enemies/ghost.tscn")

func _on_Timer_timeout():
	var instance = ghost.instance()
	add_child(instance)
