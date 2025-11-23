@tool
extends Control
class_name CraftingMenuItem

@export var building: Building

@onready var texture_rect: TextureRect = $TextureRect
@onready var menu_name: Label = $MenuName
@onready var button: Button = $Button

@onready var wood_value: Label = %WoodValue
@onready var stone_value: Label = %StoneValue
@onready var steel_value: Label = %SteelValue

@onready var wood_container: HBoxContainer = %WoodContainer
@onready var stone_container: HBoxContainer = %StoneContainer
@onready var steel_container: HBoxContainer = %SteelContainer

func _ready() -> void:
	menu_name.text = building.name
	
	wood_value.text = str(building.wood_cost)
	stone_value.text = str(building.stone_cost)
	steel_value.text = str(building.steel_cost)
	
	wood_container.modulate = Color.WHITE if building.wood_cost != 0 else Color.TRANSPARENT
	stone_container.modulate = Color.WHITE if building.stone_cost != 0 else Color.TRANSPARENT
	steel_container.modulate = Color.WHITE if building.steel_cost != 0 else Color.TRANSPARENT
	
	texture_rect.texture = building.recipe_texture
	
	if not Engine.is_editor_hint():
		update_resource(0)
		ResourceManager.wood_changed.connect(update_resource)
		ResourceManager.stone_changed.connect(update_resource)
		ResourceManager.steel_changed.connect(update_resource)

func _on_button_pressed() -> void:
	EventBus.craft_building.emit(building)

func update_resource(_updated):
	button.disabled = ResourceManager.current_wood < building.wood_cost or ResourceManager.current_stone < building.stone_cost or ResourceManager.current_steel < building.steel_cost
