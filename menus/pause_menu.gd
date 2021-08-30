extends CanvasLayer

var label_idx = 0
var paused = false setget set_paused

onready var resume_label = $ColorRect/HBoxContainer/VBoxContainer/ResumeLabel
onready var restart_label = $ColorRect/HBoxContainer/VBoxContainer/RestartLabel
onready var exit_label = $ColorRect/HBoxContainer/VBoxContainer/ExitLabel
onready var labels = [resume_label, restart_label, exit_label]

func _ready() -> void:
	Utils.toggle(labels[label_idx], true)

func set_paused(value):
	paused = value
	get_tree().paused = paused
	$ColorRect.visible = paused

func _process(_delta: float) -> void:
	var current_label = labels[label_idx]
	if Input.is_action_just_pressed("ui_cancel") and get_tree().get_nodes_in_group("Human").size() > 0:
		reset_labels()
		self.paused = !paused

	if not $ColorRect.visible:
		return

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
		reset_labels()
		match current_label:
			exit_label:
				# warning-ignore:return_value_discarded
				get_tree().change_scene("res://menus/start_menu.tscn")
			restart_label:
				# warning-ignore:return_value_discarded
				get_tree().change_scene("res://levels/" + Utils.current_level_stats["name"] + ".tscn")
			resume_label:
				pass

func reset_labels():
	Utils.toggle(labels[label_idx], false)
	label_idx = 0
	Utils.toggle(labels[label_idx], true)
