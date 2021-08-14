extends Node

onready var sound_players = get_children()

var cache = {}
var sounds_path = "res://sounds/"

func _ready():
	for file in Utils.list_files_in_directory(sounds_path, ".wav"):
		cache[file] = load(sounds_path + file)

func play(file_name, pitch_scale = 1, volume_db = 0):
	for player in sound_players:
		if not player.playing:
			player.pitch_scale = pitch_scale
			player.volume_db = volume_db
			player.stream = cache[file_name]
			player.play()
			return
	print(OS.get_time(), "Error: too many sounds so couldnt' play:", file_name)
