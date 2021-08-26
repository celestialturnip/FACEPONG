extends CenterContainer

var label_idx = 0

onready var labels = [$VBoxContainer/ContinueLabel]

func _ready():
	SoundFX.play("level_clear.wav")
	Utils.toggle(labels[label_idx], true)
	
	var seconds_taken = OS.get_unix_time() - Utils.level_stats["started_at"]
	$VBoxContainer/TimeTakenLabel.text = "Time Taken: " + "%02d" % (seconds_taken / 60) + ":" + "%02d" % (seconds_taken % 60)
	
	$VBoxContainer/GoalsLabel.text = "Goals Scored: " + str(Utils.level_stats["goals"])
	$VBoxContainer/TouchesLabel.text = "Touches: " + str(Utils.level_stats["touches"])

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		SoundFX.play("menu_accept.wav")
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://menus/level_selection.tscn")
