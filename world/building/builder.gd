extends Node2D
class_name Builder

const perspective_offset = Vector2.DOWN * 8

@export var world: Node2D
@onready var building_guide: Sprite2D = $BuildingGuide
var building_guide_data: Building

func _ready() -> void:
	building_guide.visible = false
	EventBus.craft_building.connect(start_building_guide)

func _process(_delta: float) -> void:
	if building_guide.visible:
		var mouse = get_local_mouse_position()
		var asset_size = building_guide_data.texture.get_size() / Vector2(building_guide_data.texture_frame_size)
		building_guide.position = (mouse / asset_size).round() * asset_size
		
		if Input.is_action_just_pressed("confirm_build"):
			ResourceManager.current_wood -= building_guide_data.wood_cost
			ResourceManager.current_stone -= building_guide_data.stone_cost
			ResourceManager.current_steel -= building_guide_data.steel_cost
			
			var instance: Node2D = building_guide_data.scene.instantiate()
			instance.position = building_guide.position + perspective_offset
			world.add_child(instance)
			
			building_guide.visible = false
			building_guide_data = null
		
		if Input.is_action_just_pressed("cancel_build"):
			building_guide.visible = false
			building_guide_data = null

func start_building_guide(building: Building):
	if not building: 
		building_guide.visible = false
		building_guide_data = null
		return
	
	assert(building.wood_cost <= ResourceManager.current_wood)
	assert(building.stone_cost <= ResourceManager.current_stone)
	assert(building.steel_cost <= ResourceManager.current_steel)
	
	building_guide_data = building
	
	building_guide.texture = building.texture
	building_guide.hframes = building.texture_frame_size.x
	building_guide.vframes = building.texture_frame_size.y
	building_guide.frame = building.texture_frame
	building_guide.visible = true
