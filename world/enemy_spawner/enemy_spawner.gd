extends Node2D
class_name EnemySpawner

@export var spawned_move_speed : float = 100

const BASE_ENEMY = preload("uid://devxha63j6w0k")

const FAST_MELEE_ZOMBIE_DATA = preload("uid://5yq5di0dnjs")
const HEAVY_MELEE_ZOMBIE_DATA = preload("uid://vjybrkwxjgv8")
const NORMAL_RANGE_ZOMBIE_DATA = preload("uid://cea7fjn1hn54h")
const SLOW_MELEE_ZOMBIE_DATA = preload("uid://dd6b64bybbe8m")

const ENEMY_TYPES: Array[Resource] = [
	FAST_MELEE_ZOMBIE_DATA,
	HEAVY_MELEE_ZOMBIE_DATA,
	NORMAL_RANGE_ZOMBIE_DATA,
	SLOW_MELEE_ZOMBIE_DATA
]

@export var player: Player
@export var world: Node2D
@onready var enemy_spawn_timer: Timer = %EnemySpawnTimer
@onready var enemy_spawn_timer_night_only: Timer = %EnemySpawnTimerNightOnly

var spawner_index: int

func _ready() -> void:
	EventBus.time_changed.connect(
		func(time): 
			if time == "NIGHT": 
				enemy_spawn_timer_night_only.start()
			else:
				enemy_spawn_timer_night_only.stop()
	)

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
