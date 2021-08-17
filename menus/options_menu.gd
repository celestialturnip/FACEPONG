extends Control

onready var crt_label = $VBoxContainer/CRTLabel

func _ready():
	crt_label.add_color_override("font_color", Color.gold)
	crt_label.text = "CRT: " + ("ON" if CRT.is_active() else "OFF")

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		assert(!get_tree().change_scene("res://menus/start_menu.tscn"))
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		toggle(crt_label)

func toggle(label):
	CRT.toggle()
	crt_label.text = "CRT: " + ("ON" if CRT.is_active() else "OFF")
