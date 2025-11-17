extends Area2D
class_name Attack

signal zombie_entered
signal zombie_left

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		for body in get_overlapping_bodies():
			if body is Tree_:
				body.damaged()

func _on_body_entered(body: Node2D) -> void:
	body.damaged(ResourceManager.player_weapon_damage)
	zombie_entered.emit(body)

func _on_body_exited(body: Node2D) -> void:
	zombie_left.emit(body)
