extends Node2D
class_name Builder

@onready var building_guide: Sprite2D = $BuildingGuide
var building_guide_data: Building

func _ready() -> void:
	building_guide.visible = false
	EventBus.craft_building.connect(start_building_guide)

func _process(_delta: float) -> void:
	if building_guide.visible:
		var mouse = get_local_mouse_position()
		building_guide.position = (mouse / Wall.size).round() * Wall.size
		
		if Input.is_action_just_pressed("confirm_build"):
			ResourceManager.spend_wood(Wall.wood_cost)
			
			var instance: Node2D = building_guide_data.scene.instantiate()
			instance.position = building_guide.position
			add_child(instance)
			
			building_guide.visible = false
			building_guide_data = null

func start_building_guide(building: Building):
	assert(building.wood_cost <= ResourceManager.current_wood)
	building_guide_data = building
	
	building_guide.texture = building.texture
	building_guide.visible = true
