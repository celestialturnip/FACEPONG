extends Node

var palette = ["#0022c7","#002bfb","#d62816","#ff331c","#d433c7","#ff40fc","#00c525","#00f92f","#00c7c9","#00fbfe","#ccc82a","#fffc36","#cacaca","#ffffff"]
var virtual_height = ProjectSettings.get("display/window/size/height")
var virtual_width = ProjectSettings.get("display/window/size/width")

func _ready():
	randomize()

func get_random_color():
	return palette[randi() % palette.size()]

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
