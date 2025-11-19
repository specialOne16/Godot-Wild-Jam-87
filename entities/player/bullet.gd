extends Area2D
class_name Bullet

@onready var bullet_alive: Timer = %bullet_alive

@export var speed := 800

var direction := Vector2.ZERO
var player_data := ResourceManager.player_data_rm

func _ready():
	bullet_start()
	bullet_alive.connect("timeout", destroy_bullet)
	self.connect("body_entered", _on_body_entered)
	pass

func bullet_start() -> void:
	bullet_alive.start()

func destroy_bullet() -> void:
	queue_free()
	
func _physics_process(delta):
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("damaged"):
		body.damaged(player_data.weapon_damage)
		queue_free()
