extends Node2D
class_name World

const RESOURCE_SPAWNER = preload("uid://dnh1ucwwrkajw")
const ENEMY_SPAWNER = preload("uid://mh1quh77s5gw")

const MAP_SIZE = Vector2(6400, 6400)
const CHUNK_SIZE = Vector2(640, 360)
const RESOURCE_PER_CHUNK = 3

const ZOMBIE_SPAWNER_COUNT = 10

@onready var day_night_cycle: DayNightCycle = %DayNightCycle


@onready var player: Player = %Player

func _ready() -> void:
	player.position = MAP_SIZE / 2
	init_resource_spawner()
	init_zombie_spawner()
	
	EventBus.night_time_decay.connect(apply_damage_to_children)

func init_resource_spawner():
	for x in roundi(MAP_SIZE.x / CHUNK_SIZE.x): for y in roundi(MAP_SIZE.y / CHUNK_SIZE.y):
		for i in range(RESOURCE_PER_CHUNK):
			var spawner: ResourceSpawner = RESOURCE_SPAWNER.instantiate()
			spawner.name = "ResourceSpawner%d%d%d" % [x, y, i]
			spawner.world = self
			spawner.position = Vector2(
				randf_range(CHUNK_SIZE.x * x, CHUNK_SIZE.x * (x + 1)),
				randf_range(CHUNK_SIZE.y * y, CHUNK_SIZE.y * (y + 1))
			)
			add_child(spawner)

func init_zombie_spawner():
	for i in range(ZOMBIE_SPAWNER_COUNT):
		var spawner: EnemySpawner = ENEMY_SPAWNER.instantiate()
		spawner.world = self
		spawner.player = player
		spawner.spawner_index = i
		add_child(spawner)


func apply_damage_to_children(damage_amount: int, root: Node = self):
	for child in root.get_children():
		# Recursively check children-of-children
		apply_damage_to_children(damage_amount, child)

		# Skip groups you don't want to damage
		if child.is_in_group("enemies"): 
			continue
		if child.is_in_group("walls"): 
			continue
		if child.is_in_group("objects"):
			continue

		# Apply damage if the node has a damaged() method
		if child.has_method("damaged"):
			child.damaged(damage_amount)
