extends Control

var levels = ["1", "2", "3"]
var level_idx = 0 
onready var face_texture = $CenterContainer/VBoxContainer/HBoxContainer/TextureRect

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		SoundFX.play("menu_accept.wav")
		assert(!get_tree().change_scene("res://levels/level0{idx}.tscn".format({"idx": levels[level_idx]})))
	elif Input.is_action_just_pressed("ui_left"):
		level_idx = (level_idx - 1) % len(levels)
		update_level_label()
	elif Input.is_action_just_pressed("ui_right"):
		level_idx = (level_idx + 1) % len(levels)
		update_level_label()

func update_level_label():
	$CenterContainer/VBoxContainer/LevelLabel.text = "0" + levels[level_idx]
	SoundFX.play("menu_navigation.wav", rand_range(0.95, 1.05))

func _on_Timer_timeout():
	face_texture.modulate = Utils.get_random_color()
