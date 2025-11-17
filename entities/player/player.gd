extends CharacterBody2D
class_name Player

@export var speed = 400
@onready var bullet_spawn: Marker2D = %bulletspawn
@onready var zombie_attack: Attack = %ZombieAttack
@onready var bullet_interval: Timer = %bulletInterval
@onready var gun: Sprite2D = %gun

@export var bulletScene : PackedScene = preload("res://entities/player/bullet.tscn")

var is_enemy_inside : bool = false
var enemy_direction : Vector2
var enemy_rotation: float
var enemy_body : Node2D

func _ready() -> void:
	connect_signals()

func connect_signals() -> void:
	zombie_attack.zombie_entered.connect(enemy_inside)
	zombie_attack.zombie_left.connect(enemy_outside)
	bullet_interval.timeout.connect(fire_bullet)

func enemy_inside(body: Node2D) -> void:
	is_enemy_inside = true
	bullet_interval.start()
	enemy_body = body
	
func enemy_outside(_body: Node2D) -> void:
	is_enemy_inside = false
	bullet_interval.stop()
	
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(_delta):
	get_input()
	move_and_slide()
	if is_enemy_inside == true:
		enemy_direction = (enemy_body.global_position - gun.global_position).normalized()
		gun.look_at(enemy_body.global_position)

func fire_bullet() -> void:
	var bullet := bulletScene.instantiate()
	#bullet.direction = (bullet_spawn.global_position - global_position).normalized()
	bullet.direction = enemy_direction.normalized()
	bullet.global_position = bullet_spawn.global_position
	get_tree().current_scene.call_deferred("add_child",bullet)
