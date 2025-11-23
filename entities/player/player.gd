extends CharacterBody2D
class_name Player


@export var speed = 250.0
@export var max_health = 100.0
@export var bullet_damage = 50.0

@onready var bullet_spawn: Marker2D = %bulletspawn
@onready var zombie_attack: Attack = %ZombieAttack
@onready var bullet_interval: Timer = %bulletInterval
@onready var gun_container: Node2D = $GunContainer
@onready var gun: AnimatedSprite2D = %gun
@onready var player_hp_bar: TextureProgressBar = %PlayerHPBar
@onready var player_anim: BaseAnim = $PlayerAnim

var bulletScene : PackedScene = preload("uid://c0xqahtmvo8kf")

var is_enemy_inside : bool = false
var nearest_enemy_direction : Vector2
var nearest_enemy_rotation: float
var nearest_enemy_body : Node2D
var enemies : Array

var attacking := false

var current_health = max_health :
	set(value):
		if value > max_health: current_health = max_health
		else: current_health = value

func _ready() -> void:
	player_hp_bar.max_value = max_health
	player_hp_bar.value = current_health
	
	connect_signals()

func _process(_delta: float) -> void:
	
	if enemies.is_empty() == false:
		nearest_enemy_body = get_nearest_enemy()
	
	if enemies.is_empty():
		is_enemy_inside = false
		bullet_interval.stop()
		
	if is_enemy_inside == true:
		nearest_enemy_direction = (nearest_enemy_body.global_position - global_position).normalized()
		gun_container.look_at(nearest_enemy_body.global_position)

func damaged(amount: float):
	current_health -= amount
	player_hp_bar.value = current_health
	
	if current_health <= 0:
		EventBus.player_died.emit()

func connect_signals() -> void:
	zombie_attack.zombie_entered.connect(enemy_inside)
	zombie_attack.zombie_left.connect(enemy_outside)
	bullet_interval.timeout.connect(fire_bullet)
	EventBus.connect("zombieDead",zombie_died)
	

func enemy_inside(body: Node2D) -> void:
	enemies.append(body)
	is_enemy_inside = true
	bullet_interval.start()
	
func enemy_outside(body: Node2D) -> void:
	enemies.erase(body)
	
func get_input():
	if attacking:
		velocity = Vector2.ZERO
		return
	
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	if input_direction:
		player_anim.walk()
	else:
		player_anim.idle()

func zombie_died(body: Node2D) -> void:
	enemies.erase(body)

func _physics_process(_delta):
	get_input()
	move_and_slide()

func fire_bullet() -> void:
	gun.play("attack")
	
	var bullet: Bullet = bulletScene.instantiate()
	bullet.direction = nearest_enemy_direction.normalized()
	bullet.global_position = bullet_spawn.global_position
	bullet.damage = bullet_damage
	bullet.set_collision_mask_value(2, true)
	get_tree().current_scene.call_deferred("add_child",bullet)

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
