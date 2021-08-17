extends CanvasLayer

func is_active():
	return $ColorRect.visible

func toggle():
	$ColorRect.visible = !$ColorRect.visible
