extends Control
class_name CraftingMenu

@onready var panel: PanelContainer = $Panel

func _ready() -> void:
	panel.visible = false
	EventBus.craft_building.connect(building_selected)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("build_menu"):
		panel.visible = not panel.visible
		EventBus.craft_building.emit(null)

func building_selected(building):
	if building: panel.visible = false
