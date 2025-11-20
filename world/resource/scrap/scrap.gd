extends Node2D
class_name Scrap

var spawner: ResourceSpawner

func damaged():
	ResourceManager.current_steel += 5
	spawner.start_spawn_delay()
	queue_free()
