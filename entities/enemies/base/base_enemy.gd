extends Node2D
class_name BaseEnemy

var move_speed: float = 0
var player: Player
#
func _process(_delta: float) -> void:
	rotation = get_parent().rotation
	#if player:
		#position += position.direction_to(player.global_position) * move_speed * delta
