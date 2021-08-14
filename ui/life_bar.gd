extends TextureRect

func set_health(value):
	rect_size.x = value * 3
	if value == 0: visible = false
