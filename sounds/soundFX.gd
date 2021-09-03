extends Node

onready var sound_players = get_children()

var cache = {}
var enabled = true
var sounds_path = "res://sounds/"

func _ready():
	for file in Utils.list_files_in_directory(sounds_path, ".wav.import"):
		# Remove .import from file name for audio to work when exported.
		# See https://godotengine.org/qa/96597/audio-crashes-and-missing-on-exported-project-3-2-3
		file = file.rstrip(".import")
		cache[file] = load(sounds_path + file)

func play(file_name, pitch_scale = 1, volume_db = -10):
	if not enabled: return
	for player in sound_players:
		if not player.playing:
			player.pitch_scale = pitch_scale
			player.volume_db = volume_db
			player.stream = cache[file_name]
			player.play()
			return
	print(OS.get_system_time_msecs() , "Error: too many sounds so couldnt' play:", file_name)
