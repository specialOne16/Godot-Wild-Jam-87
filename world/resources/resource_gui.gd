extends Control
class_name ResourceGui

@onready var wood_value: Label = %WoodValue

func _ready() -> void:
	ResourceManager.wood_changed.connect(update_wood_value)


func update_wood_value(value: int):
	wood_value.text = str(value)
