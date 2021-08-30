extends Control

var label_idx = 0
var previous_animation_position = 0
onready var title = $CenterContainer/VBoxContainer/Title
onready var labels = [
	$CenterContainer/VBoxContainer/LevelLabel,
	$CenterContainer/VBoxContainer/SelectFaceLabel,
	$CenterContainer/VBoxContainer/OptionsLabel
]

func _ready():
	Utils.toggle(labels[label_idx], true)
	title.modulate = Utils.colour_dict[Utils.player_settings["colour"]]
	title.bbcode_text = "[rainbow freq=.2 val=2][center]FACEP[img]%s[/img]NG[/center][/rainbow]" % "res://player/face_{emotion}.png".format({"emotion": Utils.player_settings["emotion"]})

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
		Utils.toggle(current_label, false)
		label_idx = (label_idx + 1) % len(labels)
		Utils.toggle(labels[label_idx], true)
	elif Input.is_action_just_pressed("ui_up"):
		Utils.toggle(current_label, false)
		label_idx = (label_idx - 1) % len(labels)
		Utils.toggle(labels[label_idx], true)


