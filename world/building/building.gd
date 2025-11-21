extends Resource
class_name Building

@export var name: String

@export var wood_cost: int
@export var stone_cost: int
@export var steel_cost: int

@export var recipe_texture: Texture2D
@export var texture: Texture2D
@export var texture_frame_size: Vector2i = Vector2i.ONE
@export var texture_frame: int = 0
@export var scene: PackedScene
