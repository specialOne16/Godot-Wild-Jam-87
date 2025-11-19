extends Node2D
class_name Scrap

var spawner: ResourceSpawner

func damaged():
	ResourceManager.current_steel += 1
	spawner.start_spawn_delay()
	queue_free()
