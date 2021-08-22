extends Control

onready var crt_label = $CenterContainer/VBoxContainer/CRTLabel

func _ready():
	crt_label.add_color_override("font_color", Utils.colors["gold"])
	crt_label.text = "CRT: " + ("ON" if CRT.is_active() else "OFF")

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		SoundFX.play("menu_navigation.wav")
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://menus/start_menu.tscn")
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		SoundFX.play("menu_navigation.wav")
		toggle(crt_label)

func toggle(_label):
	CRT.toggle()
	crt_label.text = "CRT: " + ("ON" if CRT.is_active() else "OFF")
