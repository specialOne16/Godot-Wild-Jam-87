extends StaticBody2D
class_name RangedTower

@export var tower_damage: float = 10
@export var tower_hp: float = 100

@onready var tower_bullet_interval: Timer = %towerBulletInterval
@onready var range_tower_hit_range: CollisionShape2D = %rangeTowerHitRange
@onready var range_tower_damage_range: CollisionShape2D = %RangeTowerDamageRange
@onready var ranged_tower_hp_bar: TextureProgressBar = %RangedTowerHPBar
@onready var canon_animation_sprite: AnimatedSprite2D = %CanonAnimationSprite
@onready var ranged_firining_position: Marker2D = %RangedFiriningPosition
@onready var canon_pivot: Node2D = %CanonPivot
@onready var area_2d: Area2D = $Area2D


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
	area_2d.connect("body_entered",enemy_inside)
	area_2d.connect("body_exited",enemy_outside)
	EventBus.connect("zombieDead",zombie_died)
	tower_bullet_interval.timeout.connect(fire_bullet)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	ranged_tower_hp_bar.value = tower_hp
	if tower_hp <= 0:
		queue_free()
	
	#if enemies.is_empty() == false:
		#nearest_enemy_body = get_nearest_enemy()
	#
	if enemies.is_empty():
		is_enemy_inside = false
		tower_bullet_interval.stop()
		canon_animation_sprite.stop()
		
	if is_enemy_inside == true:
		nearest_enemy_direction = (nearest_enemy_body.global_position - global_position).normalized()
		## TODO: We will need the gun position and gun to look at
		#canon_pivot.look_at(nearest_enemy_body.global_position)
		nearest_enemy_direction = (nearest_enemy_body.global_position - ranged_firining_position.global_position).normalized()
		nearest_enemy_rotation = nearest_enemy_direction.angle()
		# 0.1 = rotation speed (lower is slower, higher is faster)
		canon_pivot.rotation = lerp_angle(canon_pivot.rotation, nearest_enemy_rotation, 0.1)

func zombie_died(body: Node2D) -> void:
	enemies.erase(body)
	nearest_enemy_body = get_nearest_enemy()

func fire_bullet() -> void:
	var bullet := bulletScene.instantiate()
	bullet.damage = tower_damage
	bullet.direction = nearest_enemy_direction.normalized()
	# bullet will be shot from center of tower. Can place a marker to change it
	bullet.global_position = ranged_firining_position.global_position
	get_tree().current_scene.call_deferred("add_child",bullet)

func enemy_inside(body: Node2D) -> void:
	if body.is_in_group("enemies")  :
		enemies.append(body)
		is_enemy_inside = true
		tower_bullet_interval.start()
		nearest_enemy_body = get_nearest_enemy()
	
	# ANIMATION
	canon_animation_sprite.play("canon_shoot")
	
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
