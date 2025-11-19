extends StaticBody2D
class_name Tree_

var spawner: ResourceSpawner

func damaged():
	ResourceManager.current_wood += 10
	spawner.start_spawn_delay()
	queue_free()
