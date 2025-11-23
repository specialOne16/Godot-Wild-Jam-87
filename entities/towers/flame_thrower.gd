extends StaticBody2D
class_name FlameThrower

@export var tower_damage: float = 10
@export var tower_hp : float = 100

@onready var flame_thrower_attack_range: CollisionShape2D = %FlameThrowerAttackRange
@onready var flame_thrower_fire_rate: Timer = %FlameThrowerFireRate
@onready var flame_thrower_hp_bar: TextureProgressBar = %FlameThrowerHPBar
@onready var flame_thrower_detection_range: CollisionShape2D = %FlameThrowerDetectionRange
@onready var flame: Flame = %Flame
@onready var flame_thrower_sprite: AnimatedSprite2D = %flameThrowerSprite
@onready var flame_pivot: Node2D = %FlamePivot
@onready var area_2d: Area2D = $Area2D


var is_enemy_inside : bool = false
var nearest_enemy_direction : Vector2
var nearest_enemy_rotation: float
var nearest_enemy_body : Node2D
#enemies list needs to be exclusive to towers and not global as each one will have their own targets.
var enemies : Array 
var animation_stopper: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_signals()
	flame.fire_damage = tower_damage

func connect_signals() -> void:
	area_2d.connect("body_entered",enemy_inside)
	area_2d.connect("body_exited",enemy_outside)
	EventBus.connect("zombieDead",zombie_died)
	flame_thrower_fire_rate.timeout.connect(fire_bullet)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	flame_thrower_hp_bar.value = tower_hp
	if tower_hp <= 0:
		queue_free()
	
		
	if enemies.is_empty():
		is_enemy_inside = false
		animation_stopper = 0
		if flame_thrower_fire_rate.is_stopped() == false:
			animation_stopper = 1
		flame_thrower_fire_rate.stop()
		
	if animation_stopper == 1:
		flame_thrower_sprite.play("flameend")
		
	if is_enemy_inside == true:
		nearest_enemy_direction = (nearest_enemy_body.global_position - flame_thrower_sprite.global_position).normalized()
		nearest_enemy_rotation = nearest_enemy_direction.angle()
		# 0.1 = rotation speed (lower is slower, higher is faster)
		flame_pivot.rotation = lerp_angle(flame_pivot.rotation, nearest_enemy_rotation, 0.02)
		

func zombie_died(body: Node2D) -> void:
	enemies.erase(body)
	nearest_enemy_body = get_nearest_enemy()


func fire_bullet() -> void:
	flame.direction = nearest_enemy_direction.normalized()
	flame.fire()

func enemy_inside(body: Node2D) -> void:
	if body.is_in_group("enemies")  :
		enemies.append(body)
		is_enemy_inside = true
		flame_thrower_fire_rate.start()
		nearest_enemy_body = get_nearest_enemy()
		flame_thrower_sprite.play("flameStart")
		
	
func enemy_outside(body: Node2D) -> void:
	enemies.erase(body)


func damaged(damage: float) -> void:
	tower_hp -= damage



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
