extends Area2D
class_name SafeHouse
@onready var safe_area: CollisionShape2D = %safeArea


func _on_safe_area_child_entered_tree(_node: Node) -> void:
	event_bus.inside_safe_house = true


func _on_safe_area_child_exiting_tree(_node: Node) -> void:
	event_bus.inside_safe_house = false
