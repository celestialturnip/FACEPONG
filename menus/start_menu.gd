extends Control

onready var face_texture = $CenterContainer/VBoxContainer/HBoxContainer/TextureRect
onready var level_label = $CenterContainer/VBoxContainer/LevelLabel
onready var options_label = $CenterContainer/VBoxContainer/OptionsLabel

var levels = ["1", "2", "3", "4"]
var level_idx = 0 

onready var labels = [level_label, options_label]
var label_idx = 0

func _ready():
	labels[label_idx].add_color_override("font_color", Utils.colors["gold"])

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		SoundFX.play("menu_accept.wav")
		if labels[label_idx] == level_label:
			assert(!get_tree().change_scene("res://levels/level0{idx}.tscn".format({"idx": levels[level_idx]})))
		else:
			assert(!get_tree().change_scene("res://menus/options_menu.tscn"))
	elif Input.is_action_just_pressed("ui_left"):
		level_idx = (level_idx - 1) % len(levels)
		update_level_label()
	elif Input.is_action_just_pressed("ui_right"):
		level_idx = (level_idx + 1) % len(levels)
		update_level_label()
	elif Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up"):
		clear_label()
		label_idx = (label_idx + 1) % len(labels)
		update_level_label()

func clear_label():
	labels[label_idx].add_color_override("font_color", Utils.colors["white"])

func update_level_label():
	$CenterContainer/VBoxContainer/LevelLabel.text = "0" + levels[level_idx]
	labels[label_idx].add_color_override("font_color", Utils.colors["gold"])
	SoundFX.play("menu_navigation.wav")

func _on_Timer_timeout():
	face_texture.modulate = Utils.random_color()
