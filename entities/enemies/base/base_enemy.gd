extends Node2D
class_name BaseEnemy

var move_speed: float = 0
var player: Player
#
func _process(delta: float) -> void:
	# TODO : when day arrives need to either stop zombies attacking player.
	if player:
		global_position += global_position.direction_to(player.global_position) * move_speed * delta;
		look_at(player.global_position)
