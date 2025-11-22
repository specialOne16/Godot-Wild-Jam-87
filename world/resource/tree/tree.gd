extends StaticBody2D
class_name Tree_

var spawner: ResourceSpawner
@onready var sprite_2d: Sprite2D = $Sprite2D

const NORMAL_TREE = preload("uid://byo2wuhixleya")
const PINE_TREE = preload("uid://3frhexceesbi")

func _ready() -> void:
	sprite_2d.texture = [NORMAL_TREE, PINE_TREE].pick_random()
	sprite_2d.flip_h = randi_range(0, 1) == 0

func damaged():
	ResourceManager.current_wood += 10
	spawner.spawned = false
	queue_free()
