extends Node
class_name BaseAnim

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func walk():
	animation_player.play("Walk")

func attack():
	animation_player.play("Attack")

func idle():
	animation_player.play("Idle")
