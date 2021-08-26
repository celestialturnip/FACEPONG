extends Node


# warning-ignore-all:unused_signal
signal ball_entered_net
signal player_health_changed
signal player_died
signal player_ready

func emit(signal_name):
	emit_signal(signal_name)
