extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var texture_rect: TextureRect = $TextureRect

func _ready() -> void:
	$VBoxContainer.visible = false
	animation_player.play("RESET")
	
	await animation_player.animation_finished
	texture_rect.visible = false
	$VBoxContainer.visible = true


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://world/world.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
