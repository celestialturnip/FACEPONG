extends Node

var bg_color = "#1a020e"
# https://lospec.com/palette-list/pico-8
var palette = ['#1D2B53', '#7E2553', '#008751', '#AB5236', '#5F574F', '#C2C3C7', '#FFF1E8', '#FF004D', '#FFA300', '#FFEC27', '#00E436', '#29ADFF', '#83769C', '#FF77A8', '#FFCCAA']
var car_palette = palette.slice(1, len(palette) - 1)
var colors = {"gold": Color("#FFA300"), "orange": Color("#FFA300"), "white": Color("#FFF1E8"), "red": Color("#FF004D"), "yellow": Color("FFEC27")}

var colour_dict = {
	"navy": Color("#1D2B53"),
	"purple": Color("#7E2553"),
	"green": Color("#008751"),
	"olive": Color("#AB5236"),
	"gray": Color("#5F574F"),
	"silver": Color("#C2C3C7"),
	"red": Color("#FF004D"),
	"orange": Color("#FFA300"),
	"yellow": Color("#FFEC27"),
	"lime": Color("#00E436"),
	"dodger": Color("29ADFF"),
	"thistle": Color("#83769C"),
	"violet": Color("#FF77A8"),
	"wood": Color("FFCCAA")
}

var player_settings = {"emotion": "happy", "colour": "yellow"}

var previous_level_scene_path = null
var virtual_height = ProjectSettings.get("display/window/size/height")
var virtual_width = ProjectSettings.get("display/window/size/width")
var MainInstances = ResourceLoader.MainInstances

func _ready():
	randomize()
	# warning-ignore:return_value_discarded
	Signals.connect("player_died", self, "_on_player_died")

func _on_player_died():
	yield(get_tree().create_timer(1.0), "timeout")
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://menus/game_over.tscn")

func get_random_player(exclude = null):
	var random_player = random_choice(get_tree().get_nodes_in_group("Player"))
	while random_player == exclude:
		random_player = random_choice(get_tree().get_nodes_in_group("Player"))
	return random_player

func random_color():
	return random_choice(palette)

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
