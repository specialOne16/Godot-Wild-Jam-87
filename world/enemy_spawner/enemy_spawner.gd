extends Node2D
class_name EnemySpawner

const BASE_ENEMY = preload("uid://devxha63j6w0k")

@export var player: Player
@onready var spawn_timer: Timer = $SpawnTimer
@onready var path_1: Path2D = %Path1
@onready var path_follow_1: PathFollow2D = %PathFollow1


func _ready() -> void:
	spawn_timer.start()
	spawn_timer.timeout.connect(spawn_enemy)

func spawn_enemy():
	if event_bus.enemy_spawner == true:
		var enemy: BaseEnemy = BASE_ENEMY.instantiate()
		enemy.player = player
		add_child(enemy)
		# Create a follower for the path
		var follower := PathFollow2D.new()
		follower.rotates = true  # optional
		
		# Put the enemy inside the follower
		follower.add_child(enemy)

		# Add the follower to the Path2D
		path_follow_1.add_child(follower)
