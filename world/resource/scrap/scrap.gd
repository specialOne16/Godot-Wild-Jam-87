extends Node2D
class_name Scrap

var spawner: ResourceSpawner

func damaged():
	ResourceManager.current_steel += 5
	spawner.spawned = false
	queue_free()
