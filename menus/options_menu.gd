extends Control

var label_idx = 0
onready var crt_label = $CenterContainer/VBoxContainer/CRTLabel
onready var back_label = $CenterContainer/VBoxContainer/BackLabel
onready var labels = [crt_label, back_label]

func _ready():
	toggle(labels[label_idx], true)

func _process(_delta):
	var current_label = labels[label_idx]
	
	match current_label:
		crt_label:
			if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
				SoundFX.play("menu_navigation.wav")
				CRT.toggle()
				crt_label.text = "CRT: ON" if CRT.is_active() else "CRT: OFF"
		back_label:
			if Input.is_action_just_pressed("ui_accept"):
				SoundFX.play("menu_accept.wav")
				# warning-ignore:return_value_discarded
				get_tree().change_scene("res://menus/start_menu.tscn")

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
		SoundFX.play("menu_navigation.wav")
		
	else:
		label.add_color_override("font_color", Utils.colors["orange"])

