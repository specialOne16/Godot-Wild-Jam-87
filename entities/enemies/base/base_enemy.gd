extends Node2D
class_name BaseEnemy

var move_speed: float = 0
var player: Player
#
func _process(delta: float) -> void:
	if player and event_bus.enemy_spawner == true:
		global_position += global_position.direction_to(player.global_position) * move_speed * delta;
		look_at(player.global_position)
