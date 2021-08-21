extends CenterContainer

var colours = Utils.colour_dict.keys()
var colour_idx = colours.find(Utils.player_settings["colour"])

var emotions = ["happy", "mad", "sad", "???"]
var emotion_idx = emotions.find(Utils.player_settings["emotion"])

var label_idx = 0

onready var labels = [
	$VBoxContainer/HBoxContainer/ColourLabel,
	$VBoxContainer/HBoxContainer2/EmotionLabel,
]

func _ready() -> void:
	toggle(labels[label_idx], true)
	update_colour()
	update_emotion()

func update_colour():
	$VBoxContainer/TextureRect.modulate = Utils.colour_dict[colours[colour_idx]]
	$VBoxContainer/HBoxContainer/ColourLabel.text = colours[colour_idx].to_upper()

func update_emotion():
	var texture = load("res://player/face_{emotion}.png".format({"emotion": emotions[emotion_idx]}))
	$VBoxContainer/TextureRect.set_texture(texture)
	$VBoxContainer/HBoxContainer2/EmotionLabel.text = emotions[emotion_idx].to_upper()
				
func _process(_delta: float) -> void:
	var current_label = labels[label_idx]
	if Input.is_action_just_pressed("ui_down"):
		toggle(current_label, false)
		label_idx = (label_idx + 1) % labels.size()
		toggle(labels[label_idx], true)

	elif Input.is_action_just_pressed("ui_up"):
		toggle(current_label, false)
		label_idx = (label_idx - 1) % labels.size()
		toggle(labels[label_idx], true)
	
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		var left = Input.is_action_just_pressed("ui_left")
		match current_label.name:
			"ColourLabel":
				if left:
					colour_idx = (colour_idx - 1) % len(colours)
				else:
					colour_idx = (colour_idx + 1) % len(colours)
				update_colour()
			"EmotionLabel":
				if left:
					emotion_idx = (emotion_idx - 1) % len(emotions)
				else:
					emotion_idx = (emotion_idx + 1) % len(emotions)
				update_emotion()

	if Input.is_action_just_pressed("ui_accept"):
		SoundFX.play("menu_accept.wav")
		Utils.player_settings = {"emotion": emotions[emotion_idx], "colour": colours[colour_idx]}
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://menus/start_menu.tscn")

	if Input.is_action_just_pressed("ui_cancel"):
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://menus/start_menu.tscn")

func toggle(label, on: bool):
	if not on:
		label.add_color_override("font_color", Utils.colors["white"])
		label.text = label.text.capitalize()
		SoundFX.play("menu_navigation.wav")
	else:
		label.add_color_override("font_color", Utils.colors["gold"])
		label.text = label.text.to_upper()
