extends HBoxContainer

var label_idx = 0

onready var back_label = $VBoxContainer/BackLabel
onready var labels = [
	$"VBoxContainer/level01",
	$"VBoxContainer/level02",
	$"VBoxContainer/level03",
	$"VBoxContainer/level04",
	$"VBoxContainer/level05",
	back_label
]

func _ready() -> void:
	Utils.toggle(labels[label_idx], true)

func _process(_delta: float) -> void:
	var current_label = labels[label_idx]
	if Input.is_action_just_pressed("ui_down"):
		Utils.toggle(current_label, false)
		label_idx = (label_idx + 1) % labels.size()
		Utils.toggle(labels[label_idx], true)

	elif Input.is_action_just_pressed("ui_up"):
		Utils.toggle(current_label, false)
		label_idx = (label_idx - 1) % labels.size()
		Utils.toggle(labels[label_idx], true)

	if Input.is_action_just_pressed("ui_accept"):
		SoundFX.play("menu_accept.wav")
		if current_label == back_label:
			# warning-ignore:return_value_discarded
			get_tree().change_scene("res://menus/start_menu.tscn")
		var level_scene_path = "res://levels/{name}.tscn".format({"name": current_label.name.to_lower()})
		Utils.previous_level_scene_path = level_scene_path
		Utils.reset_level_stats()
		# warning-ignore:return_value_discarded
		get_tree().change_scene(level_scene_path)

	if Input.is_action_just_pressed("ui_cancel"):
		SoundFX.play("menu_navigation.wav")
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://menus/start_menu.tscn")

