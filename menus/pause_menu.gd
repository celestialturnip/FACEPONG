extends CanvasLayer

var label_idx = 0
var paused = false setget set_paused

onready var labels = [
	$ColorRect/HBoxContainer/VBoxContainer/ResumeLabel,
	$ColorRect/HBoxContainer/VBoxContainer/RestartLabel,
	$ColorRect/HBoxContainer/VBoxContainer/ExitLabel
]

func _ready() -> void:
	Utils.toggle(labels[label_idx], true)

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
		Utils.toggle(labels[label_idx], false)
		label_idx = (label_idx + 1) % labels.size()
		Utils.toggle(labels[label_idx], true)

	elif Input.is_action_just_pressed("ui_up"):
		Utils.toggle(labels[label_idx], false)
		label_idx = (label_idx - 1) % labels.size()
		Utils.toggle(labels[label_idx], true)
	
	if Input.is_action_just_pressed("ui_accept"):
		self.paused = !paused
		SoundFX.play("menu_accept.wav")
		label_idx = 0  # Reset it back to zero so next time player opens pause, the first label is selected.
		match current_label.text:
			"EXIT":
				# warning-ignore:return_value_discarded
				get_tree().change_scene("res://menus/start_menu.tscn")
			"RESTART":
				# warning-ignore:return_value_discarded
				get_tree().change_scene("res://levels/level01.tscn")
			"RESUME":
				pass
