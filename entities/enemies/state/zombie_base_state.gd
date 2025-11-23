extends State
class_name ZombieBaseState

@export var enemy: BaseEnemy

func _ready() -> void:
	if not enemy: enemy = $"../.."
