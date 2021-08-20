extends Control

onready var face_texture = $CenterContainer/VBoxContainer/HBoxContainer/TextureRect

var levels = ["1", "2", "3", "4", "5"]
var level_idx = 0 

onready var labels = [$CenterContainer/VBoxContainer/LevelLabel, $CenterContainer/VBoxContainer/OptionsLabel]
var label_idx = 0

func _ready():
	toggle(labels[label_idx], true)

func _process(_delta):
	var current_label = labels[label_idx]

	if Input.is_action_just_pressed("ui_accept"):
		SoundFX.play("menu_accept.wav")
		if label_idx == 0:
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://levels/level0{idx}.tscn".format({"idx": levels[level_idx]}))
		else:
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://menus/options_menu.tscn")
		return

	# Change label on level selection.
	if label_idx == 0:
		if Input.is_action_just_pressed("ui_left"):
			level_idx = (level_idx - 1) % levels.size()
		if Input.is_action_just_pressed("ui_right"):
			level_idx = (level_idx + 1) % levels.size()
		current_label.text = "LEVEL 0%s" % levels[level_idx]
		
	if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up"):
		toggle(current_label, false)
		label_idx = (label_idx + 1) % len(labels)
		toggle(labels[label_idx], true)

func toggle(label, on: bool):
	if not on:
		label.add_color_override("font_color", Utils.colors["white"])
		label.text = label.text.capitalize()
		SoundFX.play("menu_navigation.wav")
	else:
		label.add_color_override("font_color", Utils.colors["gold"])
		label.text = label.text.to_upper()

func _on_Timer_timeout():
	face_texture.modulate = Utils.random_color()
