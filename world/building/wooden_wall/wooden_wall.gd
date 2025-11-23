extends StaticBody2D
class_name WoodenWall

const max_hp := 100.0
var hp := max_hp

@onready var sprite_2d: Sprite2D = $Sprite2D

func damaged(damage: float):
	hp -= damage
	
	var health_percentage = hp / max_hp
	if health_percentage > 0.65: sprite_2d.frame_coords.x = 0
	elif health_percentage > 0.35: sprite_2d.frame_coords.x = 1
	else: sprite_2d.frame_coords.x = 2
	
	if hp < 0:
		queue_free()
