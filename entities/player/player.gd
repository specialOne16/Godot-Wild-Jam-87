extends CharacterBody2D
class_name Player
@onready var Anims = $"Player Anims/AnimationPlayer"
@export var speed = 400

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	if input_direction:
		Anims.play("Walk")
	else:
		Anims.play("Idle")

func _physics_process(_delta):
	get_input()
	move_and_slide()
