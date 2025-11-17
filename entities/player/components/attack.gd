extends Area2D
class_name Attack

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		for body in get_overlapping_bodies():
			if body is Tree_:
				body.damaged()
