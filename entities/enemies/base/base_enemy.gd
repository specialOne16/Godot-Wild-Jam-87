extends Node2D
class_name BaseEnemy

var move_speed: float = 200
var player: Player

func _process(delta: float) -> void:
	if player:
		position += position.direction_to(player.position) * move_speed * delta
