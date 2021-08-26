extends Node


# warning-ignore-all:unused_signal
signal ai_died
signal ball_entered_net
signal ball_served
signal player_health_changed
signal player_died
signal player_ready

func emit(signal_name):
	emit_signal(signal_name)
