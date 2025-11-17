extends Node2D
class_name BaseEnemy

@export var enemy_health: float = 100;
@export var player: Player

var move_speed: float = 100
@onready var hp_bar: TextureProgressBar = %enemyHpBar

func _process(delta: float) -> void:
	# TODO : when day arrives need to either stop zombies attacking player.
	if player:
		#global_position += global_position.direction_to(player.global_position) * move_speed * delta;
		## for debugging
		global_position = get_global_mouse_position()
		look_at(player.global_position)

func damaged(damage: float) -> void:
	#enemy_health -= damage;
	if enemy_health <= 0:
		queue_free()
