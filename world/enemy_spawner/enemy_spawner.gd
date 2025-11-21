extends Node2D
class_name EnemySpawner

@export var spawned_move_speed : float = 100

const BASE_ENEMY = preload("uid://devxha63j6w0k")

const SLOW_MELEE_ZOMBIE_DATA = preload("uid://dd6b64bybbe8m")

const ENEMY_TYPES: Array[Resource] = [
	SLOW_MELEE_ZOMBIE_DATA
]

@export var player: Player
@export var world: Node2D
@onready var enemy_spawn_timer: Timer = %EnemySpawnTimer

var spawner_index: int

func _ready() -> void:
	EventBus.time_changed.connect(func(time): if time == "NIGHT": spawn_enemy())

func _process(_delta: float) -> void:
	if player:
		position = player.position + Vector2.from_angle(2 * PI * spawner_index / World.ZOMBIE_SPAWNER_COUNT) * 640

func spawn_enemy():
	if player:
		var enemy: BaseEnemy = BASE_ENEMY.instantiate()
		enemy.player = player
		enemy.data = ENEMY_TYPES.pick_random()
		enemy.position = position
		world.add_child.call_deferred(enemy)
