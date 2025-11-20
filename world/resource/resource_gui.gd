extends Control
class_name ResourceGui

@onready var wood_value: Label = %WoodValue
@onready var stone_value: Label = %StoneValue
@onready var steel_value: Label = %SteelValue

func _ready() -> void:
	#1st time update the gui when it loads
	wood_value.text = str(ResourceManager.current_wood)
	stone_value.text = str(ResourceManager.current_stone)
	steel_value.text = str(ResourceManager.current_steel)
	
	ResourceManager.wood_changed.connect(func(value): wood_value.text = str(value))
	ResourceManager.stone_changed.connect(func(value): stone_value.text = str(value))
	ResourceManager.steel_changed.connect(func(value): steel_value.text = str(value))
