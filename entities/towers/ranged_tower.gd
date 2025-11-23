extends Area2D
class_name RangedTower

@export var tower_damage: int = 10
@export var tower_hp: int = 100

@onready var tower_bullet_interval: Timer = %towerBulletInterval
@onready var range_tower_hit_range: CollisionShape2D = %rangeTowerHitRange
@onready var range_tower_damage_range: CollisionShape2D = %RangeTowerDamageRange
@onready var ranged_tower_hp_bar: TextureProgressBar = %RangedTowerHPBar


var bulletScene : PackedScene = preload("uid://c0xqahtmvo8kf")
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
	tower_bullet_interval.timeout.connect(fire_bullet)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	ranged_tower_hp_bar.value = tower_hp
	if tower_hp <= 0:
		queue_free()
	
	if enemies.is_empty() == false:
		nearest_enemy_body = get_nearest_enemy()
	
	if enemies.is_empty():
		is_enemy_inside = false
		tower_bullet_interval.stop()
		
	if is_enemy_inside == true:
		nearest_enemy_direction = (nearest_enemy_body.global_position - global_position).normalized()
		# TODO: We will need the gun position and gun to look at
		#gun.look_at(nearest_enemy_body.global_position)

func zombie_died(body: Node2D) -> void:
	enemies.erase(body)

func fire_bullet() -> void:
	var bullet := bulletScene.instantiate()
	bullet.damage = tower_damage
	bullet.direction = nearest_enemy_direction.normalized()
	# bullet will be shot from center of tower. Can place a marker to change it
	bullet.global_position = global_position
	get_tree().current_scene.call_deferred("add_child",bullet)

func enemy_inside(body: Node2D) -> void:
	enemies.append(body)
	is_enemy_inside = true
	tower_bullet_interval.start()
	
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
