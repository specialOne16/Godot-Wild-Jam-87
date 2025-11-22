extends Node2D
class_name Builder

const perspective_offset = Vector2.DOWN * 8
const valid_position_color = Color(0x42424280)
const invalid_position_color = Color(0xdb2d2b80)

var building_guide_data: Building

@export var world: Node2D
@onready var building_guide: Area2D = $BuildingGuide
@onready var building_guide_asset: Sprite2D = $BuildingGuide/BuildingGuideAsset
@onready var building_guide_collision: CollisionShape2D = $BuildingGuide/BuildingGuideCollision

func _ready() -> void:
	building_guide.visible = false
	EventBus.craft_building.connect(start_building_guide)

func _process(_delta: float) -> void:
	if building_guide.visible:
		var mouse = get_local_mouse_position()
		var asset_size = building_guide_data.texture.get_size() / Vector2(building_guide_data.texture_frame_size)
		building_guide.position = (mouse / asset_size).round() * asset_size
		
		var valid_position = check_valid_position()
		
		building_guide_asset.modulate = valid_position_color if valid_position else invalid_position_color
		
		if Input.is_action_just_pressed("confirm_build") and valid_position:
			ResourceManager.current_wood -= building_guide_data.wood_cost
			ResourceManager.current_stone -= building_guide_data.stone_cost
			ResourceManager.current_steel -= building_guide_data.steel_cost
			
			destroy_resource_spawner()
			
			var instance: Node2D = building_guide_data.scene.instantiate()
			instance.position = building_guide.position + perspective_offset
			world.add_child(instance)
			
			building_guide.visible = false
			building_guide_data = null
		
		if Input.is_action_just_pressed("cancel_build"):
			building_guide.visible = false
			building_guide_data = null

func check_valid_position() -> bool:
	for body in building_guide.get_overlapping_bodies():
		if body is StaticBody2D:
			return false
	return true

func destroy_resource_spawner():
	for body in building_guide.get_overlapping_areas():
		if body.name.contains("ResourceSpawner"):
			body.queue_free()

func start_building_guide(building: Building):
	if not building: 
		building_guide.visible = false
		building_guide_data = null
		return
	
	assert(building.wood_cost <= ResourceManager.current_wood)
	assert(building.stone_cost <= ResourceManager.current_stone)
	assert(building.steel_cost <= ResourceManager.current_steel)
	
	building_guide_data = building
	
	building_guide_asset.texture = building.texture
	building_guide_asset.hframes = building.texture_frame_size.x
	building_guide_asset.vframes = building.texture_frame_size.y
	building_guide_asset.frame = building.texture_frame
	
	(building_guide_collision.shape as RectangleShape2D).size = (
		building_guide_data.texture.get_size() / Vector2(building_guide_data.texture_frame_size)
	) * 0.9
	
	building_guide.visible = true
