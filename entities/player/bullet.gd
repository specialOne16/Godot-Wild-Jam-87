extends Area2D

@export var speed := 800
var direction := Vector2.ZERO

func _ready():
	# Move in direction of its rotation (set by player)
	#direction = Vector2.RIGHT.rotated(rotation)
	pass


func _physics_process(delta):
	position += direction * speed * delta
