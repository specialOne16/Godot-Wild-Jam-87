extends Node2D
class_name Rock

var spawner: ResourceSpawner

func damaged():
	ResourceManager.current_stone += 10
	spawner.spawned = false
	queue_free()
