extends CanvasLayer

func _ready() -> void:
	$VBoxContainer.visible = false
	$AnimatedSprite2D.play("default")
	
	await $AnimatedSprite2D.animation_finished
	$VBoxContainer.visible = true


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://world/world.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
