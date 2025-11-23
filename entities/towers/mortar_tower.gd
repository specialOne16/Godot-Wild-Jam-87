extends StaticBody2D
class_name MortarTower

@export var tower_damage: int = 10
@export var tower_hp : int = 100

@onready var mortar_damage_range: CollisionShape2D = %MortarDamageRange
@onready var mortar_detection_range: CollisionShape2D = %MortarDetectionRange
@onready var mortar_fire_rate: Timer = %MortarFireRate
@onready var mortar_tower_hp_bar: TextureProgressBar = %MortarTowerHPBar
@onready var area_2d: Area2D = $Area2D


var is_enemy_inside : bool = false
var nearest_enemy_direction : Vector2
var nearest_enemy_rotation: float
var nearest_enemy_body : Node2D
var mortar_shell : PackedScene = preload("uid://da686fr5xaikc")
#enemies list needs to be exclusive to towers and not global as each one will have their own targets.
var enemies : Array 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_signals()

func connect_signals() -> void:
	area_2d.connect("body_entered",enemy_inside)
	area_2d.connect("body_exited",enemy_outside)
	EventBus.connect("zombieDead",zombie_died)
	mortar_fire_rate.timeout.connect(fire_bullet)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	mortar_tower_hp_bar.value = tower_hp
	if tower_hp <= 0:
		queue_free()

	
	if enemies.is_empty():
		is_enemy_inside = false
		mortar_fire_rate.stop()
		
	if is_enemy_inside == true:
		nearest_enemy_direction = (nearest_enemy_body.global_position - global_position).normalized()
		# TODO: We will need the gun position and gun to look at
		#gun.look_at(nearest_enemy_body.global_position)

func zombie_died(body: Node2D) -> void:
	enemies.erase(body)
	nearest_enemy_body = get_nearest_enemy()

func fire_bullet() -> void:
	var shell = mortar_shell.instantiate()
	#shell.bullet_damage = tower_damage
	var target_position = nearest_enemy_body.global_position
	shell.direction = nearest_enemy_direction.normalized()
	shell.global_position = global_position
	get_tree().current_scene.call_deferred("add_child",shell)
	shell.launch(self.global_position, target_position)

func enemy_inside(body: Node2D) -> void:
	if body.is_in_group("enemies")  :
		enemies.append(body)
		is_enemy_inside = true
		nearest_enemy_body = get_nearest_enemy()
		mortar_fire_rate.start()
	
func enemy_outside(body: Node2D) -> void:
	enemies.erase(body)

func damaged(damage: float) -> void:
	pass

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
