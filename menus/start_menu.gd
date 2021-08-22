extends Control

var label_idx = 0
var previous_animation_position = 0
onready var face_texture = $CenterContainer/VBoxContainer/HBoxContainer/FaceTexture
onready var labels = [
	$CenterContainer/VBoxContainer/LevelLabel,
	$CenterContainer/VBoxContainer/SelectFaceLabel,
	$CenterContainer/VBoxContainer/OptionsLabel
]

func _ready():
	toggle(labels[label_idx], true)
	face_texture.modulate = Utils.colour_dict[Utils.player_settings["colour"]]
	var texture = load("res://player/face_{emotion}.png".format({"emotion": Utils.player_settings["emotion"]}))
	face_texture.set_texture(texture)

func _process(_delta):
	var current_label = labels[label_idx]

	if Input.is_action_just_pressed("ui_accept"):
		SoundFX.play("menu_accept.wav")
		match current_label.name:
			"LevelLabel":
				# warning-ignore:return_value_discarded
				get_tree().change_scene("res://menus/level_selection.tscn")
			"SelectFaceLabel":
				# warning-ignore:return_value_discarded
				get_tree().change_scene("res://menus/face_selection.tscn")
			"OptionsLabel":
				# warning-ignore:return_value_discarded
				get_tree().change_scene("res://menus/options_menu.tscn")

	if Input.is_action_just_pressed("ui_down"):
		toggle(current_label, false)
		label_idx = (label_idx + 1) % len(labels)
		toggle(labels[label_idx], true)
	elif Input.is_action_just_pressed("ui_up"):
		toggle(current_label, false)
		label_idx = (label_idx - 1) % len(labels)
		toggle(labels[label_idx], true)


func toggle(label, on: bool):
	if not on:
		label.add_color_override("font_color", Utils.colors["white"])
		label.text = label.text.capitalize()
		SoundFX.play("menu_navigation.wav")
		previous_animation_position = $AnimationPlayer.current_animation_position
		$AnimationPlayer.seek(0, true)
		$AnimationPlayer.stop()
	else:
		label.add_color_override("font_color", Utils.colors["orange"])
		# Start slide.
		label.text = label.text.to_upper()
		$AnimationPlayer.play(label.name)
		$AnimationPlayer.seek(previous_animation_position, true)

