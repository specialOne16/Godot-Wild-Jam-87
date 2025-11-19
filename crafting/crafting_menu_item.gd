@tool
extends Control
class_name CraftingMenuItem

@export var building: Building

@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label
@onready var button: Button = $Button

func _ready() -> void:
	label.text = "%s: %d Wood" % [building.name, building.wood_cost]
	texture_rect.texture = building.texture

func _on_button_pressed() -> void:
	EventBus.craft_building.emit(building)

func on_menu_opened():
	button.disabled = ResourceManager.current_wood < building.wood_cost
