extends Control

onready var face_texture = $CenterContainer/VBoxContainer/HBoxContainer/TextureRect

onready var labels = [$CenterContainer/VBoxContainer/LevelLabel, $CenterContainer/VBoxContainer/OptionsLabel]
var label_idx = 0

func _ready():
	toggle(labels[label_idx], true)

func _process(_delta):
	var current_label = labels[label_idx]

	if Input.is_action_just_pressed("ui_accept"):
		SoundFX.play("menu_accept.wav")
		match current_label.name:
			"LevelLabel":
				# warning-ignore:return_value_discarded
				get_tree().change_scene("res://menus/level_selection.tscn")
			"OptionsLabel":
				# warning-ignore:return_value_discarded
				get_tree().change_scene("res://menus/options_menu.tscn")

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
