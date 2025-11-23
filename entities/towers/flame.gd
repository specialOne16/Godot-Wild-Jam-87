extends Area2D
class_name Flame

var direction := Vector2.ZERO

@export var fire_damage : = 80
@onready var flame_duration: Timer = %flameDuration
@onready var flame_damage_tick: Timer = %flameDamageTick

var damaged_enemies: Array

func _ready():
	self.scale = Vector2.ZERO
	flame_damage_tick.wait_time = 0.5
	connect_signals()
	
	
func _process(_delta: float):
	if damaged_enemies.is_empty():
		flame_damage_tick.stop()

func connect_signals() -> void:
	self.connect("body_entered",on_body_entered)
	self.connect("body_exited",on_body_exit)
	flame_damage_tick.connect("timeout",apply_damage)
	flame_duration.timeout.connect(fire_retract)

func fire():
	var flame_tween = get_tree().create_tween().set_parallel()
	flame_tween.tween_property(self, "scale", Vector2(1,1), .25).from(Vector2.ZERO)
	
	flame_duration.start()

	# Play particles/sound if needed
	
func on_body_entered(body):
	damaged_enemies.append(body)
	flame_damage_tick.start()
	
func on_body_exit(body):
	damaged_enemies.erase(body)
	
func apply_damage() -> void:
	for body in damaged_enemies:
		if is_instance_valid(body) and body.has_method("damaged"):
			body.damaged(fire_damage)
		else:
			damaged_enemies.erase(body)
			flame_damage_tick.stop()
			
func fire_retract():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, .25).from(Vector2(1,1))
	flame_duration.stop()
