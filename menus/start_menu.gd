extends Control

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		assert(!get_tree().change_scene("res://levels/sandbox.tscn"))

func _on_Timer_timeout():
	$CenterContainer/HBoxContainer/TextureRect.modulate = Utils.get_random_color()
