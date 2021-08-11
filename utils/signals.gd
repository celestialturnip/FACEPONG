extends Node

# warning-ignore:unused_signal
signal ball_entered_net

func emit(signal_name):
	emit_signal(signal_name)
