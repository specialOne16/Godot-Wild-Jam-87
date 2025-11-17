extends Node2D
class_name EnemySpawner

@export var spawned_move_speed : float = 100

const BASE_ENEMY = preload("uid://devxha63j6w0k")

@export var player: Player
@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	spawn_timer.start()
	spawn_timer.timeout.connect(spawn_enemy)

func spawn_enemy():
	if event_bus.enemy_spawner == true:
		var enemy: BaseEnemy = BASE_ENEMY.instantiate()
		enemy.move_speed = spawned_move_speed
		enemy.player = player
		add_child(enemy)
		
