extends Node2D
class_name EnemySpawner

@export var spawned_move_speed : float = 100

const BASE_ENEMY = preload("uid://devxha63j6w0k")

@export var player: Player
@onready var enemy_spawn_timer: Timer = %EnemySpawnTimer


func _ready() -> void:
	enemy_spawn_timer.start()
	enemy_spawn_timer.timeout.connect(spawn_enemy)

func spawn_enemy():
	# Always check valid instance if you want to check object in tree or not after freeing that object
	if EventBus.enemy_spawner == true and is_instance_valid(player) and player.is_inside_tree():
		var enemy: BaseEnemy = BASE_ENEMY.instantiate()
		enemy.move_speed = spawned_move_speed
		enemy.player = player
		add_child(enemy)
		
