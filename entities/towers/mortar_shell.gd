extends Area2D
class_name MortarShell

var start_pos: Vector2
var target_pos: Vector2
var total_time := 1.2          # how long it stays in air
var time_passed := 0.0
var peak_height := 150.0       # how high the arc goes+
var direction := Vector2.ZERO

@export var explosion_radius := 64.0
@export var shell_damage:= 2.0

func _ready():
	pass
	# Optional: disable explosion area until landing
	# monitoring = false

func launch(from: Vector2, to: Vector2):
	start_pos = from
	target_pos = to
	global_position = from
	time_passed = 0.0

func _process(delta):
	time_passed += delta
	var t = time_passed / total_time

	if t >= 1:
		explode()
		queue_free()
		return

	# Linear horizontal movement
	var pos = start_pos.lerp(target_pos, t)

	# Vertical arc (parabola)
	var height = -4 * peak_height * (t - 0.5) * (t - 0.5) + peak_height
	pos.y -= height   # "lift" the projectile visually

	global_position = pos

func explode():

	# Damage all bodies in radius
	for body in get_overlapping_bodies():
		if body.has_method("damaged"):
			body.damaged(shell_damage)

	# Play particles/sound if needed
	# queue_free after a short delay
	queue_free()
