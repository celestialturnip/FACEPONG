extends Control

var label_idx = 0
onready var crt_label = $CenterContainer/VBoxContainer/CRTLabel
onready var difficulty_label = $CenterContainer/VBoxContainer/DifficultyLabel
onready var back_label = $CenterContainer/VBoxContainer/BackLabel
onready var labels = [crt_label, difficulty_label, back_label]

func _ready():
	Utils.toggle(labels[label_idx], true)
	crt_label.text = "CRT: ON" if CRT.is_active() else "CRT: OFF"
	difficulty_label.text = "Difficulty: %s" % Utils.GAME_DIFFICULTY.keys()[Utils.game_difficulty]

func _process(_delta):
	var current_label = labels[label_idx]
	
	match current_label:
		crt_label:
			if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
				SoundFX.play("menu_navigation.wav")
				CRT.toggle()
				crt_label.text = "CRT: ON" if CRT.is_active() else "CRT: OFF"
		difficulty_label:
			if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
				SoundFX.play("menu_navigation.wav")
				Utils.toggle_game_difficulty()
				difficulty_label.text = "Difficulty: %s" % Utils.GAME_DIFFICULTY.keys()[Utils.game_difficulty]
		back_label:
			if Input.is_action_just_pressed("ui_accept"):
				SoundFX.play("menu_accept.wav")
				# warning-ignore:return_value_discarded
				get_tree().change_scene("res://menus/start_menu.tscn")

	if Input.is_action_just_pressed("ui_down"):
		Utils.toggle(current_label, false)
		label_idx = (label_idx + 1) % len(labels)
		Utils.toggle(labels[label_idx], true)
	elif Input.is_action_just_pressed("ui_up"):
		Utils.toggle(current_label, false)
		label_idx = (label_idx - 1) % len(labels)
		Utils.toggle(labels[label_idx], true)
