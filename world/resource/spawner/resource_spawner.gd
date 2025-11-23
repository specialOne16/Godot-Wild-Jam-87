extends Area2D
class_name ResourceSpawner

@export var world: Node2D
@onready var resource_attack: AudioStreamPlayer = $ResourceAttack

const TREE = preload("uid://cqfsvslvri855")
const ROCK = preload("uid://cbla4cohjevo5")
const SCRAP = preload("uid://bbjwyofgg02jm")

var spawn_timer = 0
var spawned = false :
	set(value):
		if resource_attack and value == false: resource_attack.play()
		spawned = value

func _ready() -> void: 
	spawn()
	EventBus.time_changed.connect(func(time): if time == "DAY": spawn())

func spawn():
	if spawned: return
	
	var scene: PackedScene
	match randi_range(0, 10):
		0, 1, 2, 3, 4, 5, 6: scene = TREE
		7, 8, 9: scene = ROCK
		_: scene = SCRAP
	
	var resource = scene.instantiate()
	resource.spawner = self
	resource.position = position
	world.add_child.call_deferred(resource)
	spawned = true
