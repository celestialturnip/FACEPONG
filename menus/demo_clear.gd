extends CenterContainer

var label_idx = 0
onready var labels = [$VBoxContainer/ContinueLabel]

func _ready():
	SoundFX.play("level_clear.wav")
	Utils.toggle(labels[label_idx], true)
	Utils.demo_completed = true
	
	var totals = {"seconds_taken": 0, "goals": 0, "touches": 0}

	for key in Utils.all_level_stats:
		totals["seconds_taken"] += Utils.all_level_stats[key]["completed_at"] - Utils.all_level_stats[key]["started_at"]
		totals["goals"] = Utils.all_level_stats[key]["goals"]
		totals["touches"] = Utils.all_level_stats[key]["touches"]
	
	$VBoxContainer/TimeTakenLabel.text = "Time Taken: " + "%02d" % (totals["seconds_taken"] / 60) + ":" + "%02d" % (totals["seconds_taken"] % 60)
	$VBoxContainer/GoalsLabel.text = "Goals Scored: " + str(totals["goals"])
	$VBoxContainer/TouchesLabel.text = "Touches: " + str(totals["touches"])

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		SoundFX.play("menu_accept.wav")
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://menus/start_menu.tscn")
