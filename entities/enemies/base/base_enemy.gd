extends RigidBody2D
class_name BaseEnemy


@export var enemy_health: float = 100;
@export var player: Player

@onready var hp_bar: TextureProgressBar = %enemyHpBar
@onready var zombie_damage_timer: Timer = %ZombieDamageTimer
@onready var zombie_range: Area2D = %ZombieRange

var zombie_data := ResourceManager.zombie_data_rm
var player_data := ResourceManager.player_data_rm
var move_speed: float = 100

func _ready() -> void:
	hp_bar.value = enemy_health
	zombie_range.connect("body_entered", player_check)
	zombie_damage_timer.connect("timeout", player_damage)
	zombie_range.connect("body_exited", stop_damage_timer)

func player_check(body: Node2D) -> void:
	if body is Player:
		zombie_damage_timer.start()
	
func stop_damage_timer(body: Node2D) -> void:
	if body is Player:
		zombie_damage_timer.stop()
	
func player_damage() -> void:
	player_data.player_health -= zombie_data.zombie_damage
	print(player_data.player_health)

func _process(delta: float) -> void:
	# TODO : when day arrives need to either stop zombies attacking player.
	if player:
		global_position += global_position.direction_to(player.global_position) * move_speed * delta;
		look_at(player.global_position)

func damaged(damage: float) -> void:
	enemy_health -= damage;
	hp_bar.value = enemy_health

	if enemy_health <= 0:
		queue_free()
		ResourceManager.enemy_list.erase(self)
