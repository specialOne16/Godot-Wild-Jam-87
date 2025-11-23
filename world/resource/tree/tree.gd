extends StaticBody2D
class_name Tree_

var spawner: ResourceSpawner
@onready var sprite_2d: Sprite2D = $Sprite2D

const NORMAL_TREE = preload("uid://c7d74dl620lsy")
const PINE_TREE = preload("uid://ck861rou6w1xo")
const DROPS = preload("uid://b8v3hshx5sa78")

func _ready() -> void:
	sprite_2d.texture = [NORMAL_TREE, PINE_TREE].pick_random()
	sprite_2d.flip_h = randi_range(0, 1) == 0

func damaged():
	var drops : Drops = DROPS.instantiate()
	drops.global_position = self.global_position
	drops.drop = "wood"
	get_tree().current_scene.call_deferred("add_child",drops)
	
	spawner.spawned = false
	queue_free()
