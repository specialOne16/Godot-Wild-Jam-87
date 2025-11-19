extends Node2D
class_name Rock

var spawner: ResourceSpawner

func damaged():
	ResourceManager.current_stone += 5
	spawner.start_spawn_delay()
	queue_free()
