extends HBoxContainer

var label_idx = 0

onready var back_label = $VBoxContainer/BackLabel
onready var level_labels = [
	$VBoxContainer/level01/Label,
	$VBoxContainer/level02/Label,
	$VBoxContainer/level03/Label,
	$VBoxContainer/level04/Label,
	$VBoxContainer/level05/Label
]
onready var labels = level_labels + [back_label]

func _ready() -> void:
	Utils.toggle(labels[label_idx], true)
	for label in level_labels:
		label.get_parent().get_node("TextureRect").visible = label.get_parent().name in Utils.all_level_stats

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
			return
		var level_scene_path = "res://levels/{name}.tscn".format({"name": current_label.get_parent().name})
		Utils.reset_current_level_stats()
		Utils.current_level_stats["name"] = current_label.get_parent().name
		# warning-ignore:return_value_discarded
		get_tree().change_scene(level_scene_path)

	if Input.is_action_just_pressed("ui_cancel"):
		SoundFX.play("menu_navigation.wav")
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://menus/start_menu.tscn")

