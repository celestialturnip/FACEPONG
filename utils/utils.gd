extends Node

var bg_color = "#1a020e"
# https://lospec.com/palette-list/pico-8
var colour_dict = {
	"navy": Color("#1D2B53"),
	"purple": Color("#7E2553"),
	"green": Color("#008751"),
	"olive": Color("#AB5236"),
	"gray": Color("#5F574F"),
	"silver": Color("#C2C3C7"),
	"lace": Color("#FFF1E8"),
	"red": Color("#FF004D"),
	"orange": Color("#FFA300"),
	"yellow": Color("#FFEC27"),
	"lime": Color("#00E436"),
	"dodger": Color("29ADFF"),
	"thistle": Color("#83769C"),
	"violet": Color("#FF77A8"),
	"wood": Color("FFCCAA")
}
var completed_level_paths = []
var current_level_stats = {}
var player_settings = {"emotion": "happy", "colour": "yellow"}
var previous_level_scene_path = null
var virtual_height = ProjectSettings.get("display/window/size/height")
var virtual_width = ProjectSettings.get("display/window/size/width")
var MainInstances = ResourceLoader.MainInstances

# Game difficulty.
enum GAME_DIFFICULTY {EASY, HARD}
var game_difficulty = GAME_DIFFICULTY.HARD
func toggle_game_difficulty():
	game_difficulty = GAME_DIFFICULTY.EASY if game_difficulty == GAME_DIFFICULTY.HARD else GAME_DIFFICULTY.HARD

# UI shared component.
func toggle(label, on: bool):
	if not on:
		label.add_color_override("font_color", colour_dict["lace"])
		label.text = label.text.capitalize()
		SoundFX.play("menu_navigation.wav")
	else:
		label.add_color_override("font_color", colour_dict["orange"])
		label.text = label.text.to_upper()

func _ready():
	randomize()
	# warning-ignore-all:return_value_discarded
	Signals.connect("player_died", self, "_on_player_died")
	Signals.connect("ai_died", self, "_on_ai_died")
	Signals.connect("ball_served", self, "_on_ball_served")

func _on_ball_served():
	if current_level_stats["started_at"]: return
	current_level_stats["started_at"] = OS.get_unix_time()

func reset_current_level_stats():
	current_level_stats = {"started_at": null, "goals": 0, "touches": 0}

func _on_ai_died():
	# Check if any AI are alive.
	for player in get_tree().get_nodes_in_group("Player"):
		if player.is_human: continue
		if player.health > 0: return
	# Add this level to completed.
	completed_level_paths.append(previous_level_scene_path)
	# Load level clear screen.
	yield(get_tree().create_timer(1.0), "timeout")
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://menus/level_clear.tscn")

func _on_player_died():
	yield(get_tree().create_timer(1.0), "timeout")
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://menus/game_over.tscn")

func get_random_player(exclude = null):
	var random_player = random_choice(get_tree().get_nodes_in_group("Player"))
	while random_player == exclude:
		random_player = random_choice(get_tree().get_nodes_in_group("Player"))
	return random_player

func get_player_colours():
	var colours = [colour_dict[player_settings["colour"]]]
	for player in get_tree().get_nodes_in_group("Player"):
		colours += [player.colour]
	return colours

func get_random_colour():
	return colour_dict[random_choice(colour_dict.keys())]

func random_choice(list):
	return list[randi() % list.size()]

func list_files_in_directory(path, file_extension="*"):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			if file_extension == "*":
				files.append(file)
			elif file.ends_with(file_extension):
				files.append(file)

	dir.list_dir_end()

	return files
