extends Node

var palette = ["#000000","#0022c7","#002bfb","#d62816","#ff331c","#d433c7","#ff40fc","#00c525","#00f92f","#00c7c9","#00fbfe","#ccc82a","#fffc36","#cacaca","#ffffff"]
var virtual_height = ProjectSettings.get("display/window/size/height")
var virtual_width = ProjectSettings.get("display/window/size/width")

func _ready():
	randomize()

func get_random_color():
	return palette[randi() % palette.size()]
