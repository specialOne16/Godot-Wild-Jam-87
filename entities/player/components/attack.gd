extends Area2D
class_name Attack

@onready var player: Player = $".."

signal zombie_entered
signal zombie_left

func _ready() -> void:
	await player.ready
	player.player_anim.impact.connect(crush_resources)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		player.attacking = true
		await player.player_anim.attack()
		player.attacking = false

func crush_resources():
	for body in get_overlapping_bodies():
		if body is Tree_ or body is Rock or body is Scrap:
			body.damaged()

func _on_body_entered(body: Node2D) -> void:
	zombie_entered.emit(body)

func _on_body_exited(body: Node2D) -> void:
	zombie_left.emit(body)
