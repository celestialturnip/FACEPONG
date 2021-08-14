extends Node2D

export (NodePath) var player_node_path
onready var middle_post = $MiddlePost
var player = null

func _ready():
	player = get_node(player_node_path)
	$LifeBar.set_health(player.health)
	middle_post.disable()

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
