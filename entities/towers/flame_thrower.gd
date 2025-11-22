extends Area2D
class_name FlameThrower

@export var tower_damage: int = 10
@export var tower_hp : int = 100

@onready var flame_thrower_attack_range: CollisionShape2D = %FlameThrowerAttackRange
@onready var flame_thrower_fire_rate: Timer = %FlameThrowerFireRate
@onready var flame_thrower_hp_bar: TextureProgressBar = %FlameThrowerHPBar
@onready var flame_thrower_detection_range: CollisionShape2D = %FlameThrowerDetectionRange
@onready var flame: Flame = %Flame


var is_enemy_inside : bool = false
var nearest_enemy_direction : Vector2
var nearest_enemy_rotation: float
var nearest_enemy_body : Node2D
#enemies list needs to be exclusive to towers and not global as each one will have their own targets.
var enemies : Array 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_signals()

func connect_signals() -> void:
	connect("body_entered",enemy_inside)
	connect("body_exited",enemy_outside)
	EventBus.connect("zombieDead",zombie_died)
	flame_thrower_fire_rate.timeout.connect(fire_bullet)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	flame_thrower_hp_bar.value = tower_hp
	if tower_hp <= 0:
		queue_free()
	
	if enemies.is_empty() == false:
		nearest_enemy_body = get_nearest_enemy()
	
	if enemies.is_empty():
		is_enemy_inside = false
		flame_thrower_fire_rate.stop()
		
	if is_enemy_inside == true:
		nearest_enemy_direction = (nearest_enemy_body.global_position - global_position).normalized()
		#self.look_at(nearest_enemy_body.global_position)
		nearest_enemy_rotation = nearest_enemy_direction.angle()
		#self.rotation = nearest_enemy_rotation
		# 0.1 = rotation speed (lower is slower, higher is faster)
		rotation = lerp_angle(rotation, nearest_enemy_rotation, 0.01)
		

func zombie_died(body: Node2D) -> void:
	enemies.erase(body)


func fire_bullet() -> void:
	flame.direction = nearest_enemy_direction.normalized()
	flame.global_position = global_position
	flame.fire()

func enemy_inside(body: Node2D) -> void:
	if body.is_in_group("enemies")  :
		enemies.append(body)
		is_enemy_inside = true
		flame_thrower_fire_rate.start()
	
func enemy_outside(body: Node2D) -> void:
	enemies.erase(body)





func get_nearest_enemy():
	if enemies.is_empty():
		return null

	var nearest: Node2D = null
	var nearest_dist := INF

	for enemy in enemies:
		if !is_instance_valid(enemy):
			continue   # skip deleted enemies

		var dist := global_position.distance_to(enemy.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = enemy

	return nearest
