extends Node2D
class_name World

const RESOURCE_SPAWNER = preload("uid://dnh1ucwwrkajw")
const ENEMY_SPAWNER = preload("uid://mh1quh77s5gw")

const MAP_SIZE = Vector2(6400, 6400)
const CHUNK_SIZE = Vector2(640, 360)
const RESOURCE_PER_CHUNK = 3

const ZOMBIE_SPAWNER_COUNT = 10

@onready var player: Player = %Player

func _ready() -> void:
	MusicPlayer.death.stop()
	MusicPlayer.day_music.play()
	
	player.position = MAP_SIZE / 2
	init_resource_spawner()
	init_zombie_spawner()
	
	EventBus.player_died.connect(end_game)

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

func end_game():
	MusicPlayer.day_music.stop()
	MusicPlayer.night_song.stop()
	MusicPlayer.death.play()
	
	$CanvasLayer/CraftingMenu.panel.visible = false
	
	get_tree().paused = true
	%EndGameMenu.visible = true
