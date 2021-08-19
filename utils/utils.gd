extends Node

var bg_color = "#1a020e"
# https://lospec.com/palette-list/pico-8
var palette = ['#1D2B53', '#7E2553', '#008751', '#AB5236', '#5F574F', '#C2C3C7', '#FFF1E8', '#FF004D', '#FFA300', '#FFEC27', '#00E436', '#29ADFF', '#83769C', '#FF77A8', '#FFCCAA']
var car_palette = palette.slice(1, len(palette) - 1)
var colors = {"gold": Color("#FFA300"), "white": Color("#FFF1E8"), "red": "#FF004D"}
var virtual_height = ProjectSettings.get("display/window/size/height")
var virtual_width = ProjectSettings.get("display/window/size/width")

func _ready():
	randomize()

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
