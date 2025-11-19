extends Control
class_name CraftingMenu

@onready var panel: PanelContainer = $Panel
@onready var menu_items: Array[CraftingMenuItem] = [%Wall]

func _ready() -> void:
	panel.visible = false
	EventBus.craft_building.connect(building_selected)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("build_menu"):
		panel.visible = not panel.visible
		
		for menu_item in menu_items:
			menu_item.on_menu_opened()

func building_selected(_building):
	panel.visible = false
