extends CenterContainer

var label_idx = 0

onready var labels = [
	$"VBoxContainer/level01",
	$"VBoxContainer/level02",
	$"VBoxContainer/level03",
	$"VBoxContainer/level04",
	$"VBoxContainer/level05"
]

func _ready() -> void:
	toggle(labels[label_idx], true)

func _process(_delta: float) -> void:
	var current_label = labels[label_idx]
	if Input.is_action_just_pressed("ui_down"):
		toggle(current_label, false)
		label_idx = (label_idx + 1) % labels.size()
		toggle(labels[label_idx], true)

	elif Input.is_action_just_pressed("ui_up"):
		toggle(current_label, false)
		label_idx = (label_idx - 1) % labels.size()
		toggle(labels[label_idx], true)

	if Input.is_action_just_pressed("ui_accept"):
		SoundFX.play("menu_accept.wav")
		var level_scene_path = "res://levels/{name}.tscn".format({"name": current_label.name.to_lower()})
		Utils.previous_level_scene_path = level_scene_path
		# warning-ignore:return_value_discarded
		get_tree().change_scene(level_scene_path)

func toggle(label, on: bool):
	if not on:
		label.add_color_override("font_color", Utils.colors["white"])
		label.text = label.text.capitalize()
		SoundFX.play("menu_navigation.wav")
	else:
		label.add_color_override("font_color", Utils.colors["gold"])
		label.text = label.text.to_upper()
