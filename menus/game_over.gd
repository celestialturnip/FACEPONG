extends CenterContainer

var label_idx = 0

onready var labels = [$VBoxContainer/RestartLevel, $VBoxContainer/ReturnToMain]

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
		match current_label.name:
			"RestartLevel":
				# warning-ignore:return_value_discarded
				get_tree().change_scene(Utils.previous_level_scene_path)
			"ReturnToMain":
				# warning-ignore:return_value_discarded
				get_tree().change_scene("res://menus/start_menu.tscn")
