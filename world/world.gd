extends Node2D
class_name World

@onready var player: Player = %Player
@onready var base_enemy: BaseEnemy = %BaseEnemy


func _ready() -> void:
	base_enemy.player = player
