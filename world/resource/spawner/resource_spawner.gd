extends Node2D
class_name ResourceSpawner

const TREE = preload("uid://cqfsvslvri855")
const ROCK = preload("uid://cbla4cohjevo5")
const SCRAP = preload("uid://bbjwyofgg02jm")

const MIN_SPAWN_DELAY = 4.0
const MAX_SPAWN_DELAY = 6.0

var spawn_timer = 0
var spawned = false

func _ready() -> void: 
	start_spawn_delay()

func _process(delta: float) -> void:
	spawn_timer -= delta
	if spawn_timer < 0 and not spawned:
		spawn()

func start_spawn_delay():
	spawn_timer = randf_range(MIN_SPAWN_DELAY, MAX_SPAWN_DELAY)
	spawned = false

func spawn():
	var scene
	match randi_range(0, 10):
		0, 1, 2, 3, 4, 5, 6: scene = TREE
		7, 8, 9: scene = ROCK
		_: scene = SCRAP
	
	var resource = scene.instantiate()
	resource.spawner = self
	add_child(resource)
	spawned = true
