extends Camera2D

onready var timer = $Timer
var shake

func _ready():
	assert(!Signals.connect(  # The node that is emitting the signal.
		"ball_entered_net",  # The name of the signal emitted.
		self,  # The Node that will receive the signal (usually self).
		"screenshake"  # Function to run when the signal is sent.
	))

func _process(_delta):
	if not timer.time_left:
		shake = 0
	offset_h = rand_range(-shake, shake)
	offset_v = rand_range(-shake, shake)

func screenshake():
	shake = 0.1
	timer.wait_time = 0.1
	timer.start()
