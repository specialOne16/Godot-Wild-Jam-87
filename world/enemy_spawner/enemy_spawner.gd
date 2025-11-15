extends Node2D
class_name EnemySpawner

const BASE_ENEMY = preload("uid://devxha63j6w0k")

@export var player: Player
@onready var spawn_timer: Timer = $SpawnTimer

func _ready() -> void:
	spawn_timer.start()
	spawn_timer.timeout.connect(spawn_enemy)

func spawn_enemy():
	var enemy: BaseEnemy = BASE_ENEMY.instantiate()
	enemy.player = player
	add_child(enemy)
