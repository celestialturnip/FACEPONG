extends StaticBody2D

func disable():
	visible = false
	$CollisionShape2D.set_deferred("disabled", true)

func enable():
	visible = true
	$CollisionShape2D.set_deferred("disabled", false)
