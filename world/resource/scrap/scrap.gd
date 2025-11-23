extends Node2D
class_name Scrap

const DROPS = preload("uid://b8v3hshx5sa78")

var spawner: ResourceSpawner

func damaged():
	var drops : Drops = DROPS.instantiate()
	drops.global_position = self.global_position
	drops.drop = "steel"
	get_tree().current_scene.call_deferred("add_child",drops)
	
	spawner.spawned = false
	queue_free()
