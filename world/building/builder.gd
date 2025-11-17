extends Node2D
class_name Builder

const WALL = preload("uid://bg64ogjemrh2m")

@onready var wall_shadow: Sprite2D = $WallShadow

var active_shadow: Node2D

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("build_wall") and ResourceManager.current_wood >= Wall.wood_cost:
		active_shadow = wall_shadow
		active_shadow.visible = true
	
	if active_shadow:
		var mouse = get_local_mouse_position()
		active_shadow.position = (mouse / Wall.size).round() * Wall.size
		
		if Input.is_action_just_pressed("confirm_build"):
			ResourceManager.spend_wood(Wall.wood_cost)
			
			var wall: Wall = WALL.instantiate()
			wall.position = active_shadow.position
			add_child(wall)
			
			active_shadow.visible = false
			active_shadow = null
