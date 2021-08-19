extends CanvasLayer

var label_idx = 0
var paused = false setget set_paused

onready var labels = [
	$ColorRect/CenterContainer/VBoxContainer/ResumeLabel,
	$ColorRect/CenterContainer/VBoxContainer/RestartLabel,
	$ColorRect/CenterContainer/VBoxContainer/ExitLabel
]

func _ready() -> void:
	toggle(labels[label_idx], true)

func set_paused(value):
	paused = value
	get_tree().paused = paused
	$ColorRect.visible = paused

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") and get_tree().get_nodes_in_group("Player").size() > 0:
		self.paused = !paused

	if not $ColorRect.visible:
		return

	var current_label = labels[label_idx]
	if Input.is_action_just_pressed("ui_down"):
		toggle(labels[label_idx], false)
		label_idx = (label_idx + 1) % labels.size()
		toggle(labels[label_idx], true)
		SoundFX.play("menu_navigation.wav")
		
	elif Input.is_action_just_pressed("ui_up"):
		toggle(labels[label_idx], false)
		label_idx = (label_idx - 1) % labels.size()
		toggle(labels[label_idx], true)
		SoundFX.play("menu_navigation.wav")
	
	if Input.is_action_just_pressed("ui_accept"):
		self.paused = !paused
		SoundFX.play("menu_accept.wav")
		match current_label.text:
			"EXIT":
				# warning-ignore:return_value_discarded
				get_tree().change_scene("res://menus/start_menu.tscn")
			"RESTART":
				# warning-ignore:return_value_discarded
				get_tree().change_scene("res://levels/level01.tscn")
			"RESUME":
				pass

func toggle(label, on: bool):
	if not on:
		label.add_color_override("font_color", Utils.colors["white"])
		label.text = label.text.capitalize()
	else:
		label.add_color_override("font_color", Utils.colors["gold"])
		label.text = label.text.to_upper()
