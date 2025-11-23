extends Node2D
class_name BaseAnim

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var animation_to_play = "idle" :
	set(value):
		if animated_sprite_2d: animated_sprite_2d.play(value)
		animation_to_play = value

func walk():
	animation_to_play = "walk"

func attack():
	animation_to_play = "attack"
	await animated_sprite_2d.animation_finished

func idle():
	animation_to_play = "idle"

func _ready() -> void:
	animation_to_play = animation_to_play
