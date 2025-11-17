extends CharacterBody2D
class_name Player

@export var speed = 400

@onready var bullet_spawn: Marker2D = %bulletspawn
@onready var zombie_attack: Attack = %ZombieAttack
@onready var bullet_interval: Timer = %bulletInterval
@onready var gun: Sprite2D = %gun
@onready var player_hp_bar: TextureProgressBar = %PlayerHPBar

var bulletScene : PackedScene = preload("uid://c0xqahtmvo8kf")
var player_data := ResourceManager.player_data_rm

var is_enemy_inside : bool = false
var enemy_direction : Vector2
var enemy_rotation: float
var enemy_body : Node2D
var enemies : Array = ResourceManager.enemy_list

func _ready() -> void:
	connect_signals()
	
func _process(_delta: float) -> void:
	player_hp_bar.value = player_data.player_health
	if player_data.player_health <= 0:
		queue_free()
	
	if enemies.is_empty() == false:
		enemy_body = get_nearest_enemy()
	
	if enemies.is_empty():
		is_enemy_inside = false
		bullet_interval.stop()
		
	if is_enemy_inside == true:
		enemy_direction = (enemy_body.global_position - gun.global_position).normalized()
		gun.look_at(enemy_body.global_position)

func connect_signals() -> void:
	zombie_attack.zombie_entered.connect(enemy_inside)
	zombie_attack.zombie_left.connect(enemy_outside)
	bullet_interval.timeout.connect(fire_bullet)
	

func enemy_inside(body: Node2D) -> void:
	enemies.append(body)
	is_enemy_inside = true
	bullet_interval.start()
	
func enemy_outside(body: Node2D) -> void:
	enemies.erase(body)
	
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed



func _physics_process(_delta):
	get_input()
	move_and_slide()

func fire_bullet() -> void:
	var bullet := bulletScene.instantiate()
	#bullet.direction = (bullet_spawn.global_position - global_position).normalized()
	bullet.direction = enemy_direction.normalized()
	bullet.global_position = bullet_spawn.global_position
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
