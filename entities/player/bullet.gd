extends Area2D
class_name Bullet

@onready var bullet_alive: Timer = %bullet_alive
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var bullet_speed := 800
@export var damage := 60.0
@export var texture: Texture2D = preload("uid://bs5c1bo46xpm1")

var direction := Vector2.ZERO

func _ready():
	bullet_start()
	sprite_2d.texture = texture
	bullet_alive.connect("timeout", destroy_bullet)
	self.connect("body_entered", _on_body_entered)
	pass

func bullet_start() -> void:
	bullet_alive.start()

func destroy_bullet() -> void:
	queue_free()
	
func _physics_process(delta):
	position += direction * bullet_speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("damaged"):
		body.damaged(damage)
		queue_free()
