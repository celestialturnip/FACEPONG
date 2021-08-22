extends Node2D
class_name Net

export (NodePath) var player_node_path
onready var middle_post = $MiddlePost
onready var life_bar = $LifeBar
var player = null

func _ready():
	player = get_node(player_node_path)
	middle_post.disable()
	# warning-ignore-all:return_value_discarded
	Signals.connect("player_health_increased", self, "update_lifebar")
	Signals.connect("player_ready", self, "_on_player_ready")

func update_lifebar():
	life_bar.set_health(player.health)

func _on_player_ready():
	life_bar.modulate = player.get_node("Sprite").modulate
	update_lifebar()

func _on_BallDetector_body_entered(body):
	if !(body is Ball): return
	Signals.emit("ball_entered_net")
	body.reset()

	player.on_goal_allowed()
	$LifeBar.set_health(player.health)
	if player.health == 0:
		player.queue_free()
		middle_post.enable()
		$BallDetector.queue_free()
