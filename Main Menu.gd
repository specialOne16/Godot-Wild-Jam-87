extends Node2D
func _ready() -> void:
	$AnimationPlayer.play("new_animation")
	$AnimatedSprite2D.play("default")
