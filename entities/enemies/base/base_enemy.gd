extends RigidBody2D
class_name BaseEnemy


@export var enemy_health: float = 100;
@export var player: Player
@export var data: ZombieData

@onready var hp_bar: TextureProgressBar = %enemyHpBar
@onready var zombie_damage_timer: Timer = %ZombieDamageTimer
@onready var zombie_range: Area2D = %ZombieRange
var anim: BaseAnim

const DROPS = preload("uid://b8v3hshx5sa78")


var zombie_data := ResourceManager.zombie_data_rm
var player_data := ResourceManager.player_data_rm
var move_speed: float = 100

func _ready() -> void:
	hp_bar.value = enemy_health
	zombie_range.connect("body_entered", player_check)
	zombie_damage_timer.connect("timeout", player_damage)
	zombie_range.connect("body_exited", stop_damage_timer)
	
	anim = data.texture.instantiate()
	add_child(anim)

func player_check(body: Node2D) -> void:
	if body is Player:
		zombie_damage_timer.start()
	
func stop_damage_timer(body: Node2D) -> void:
	if body is Player:
		zombie_damage_timer.stop()
	
func player_damage() -> void:
	player_data.player_health -= zombie_data.zombie_damage

func _process(delta: float) -> void:
	# TODO : when day arrives need to either stop zombies attacking player.
	if player:
		global_position += global_position.direction_to(player.global_position) * move_speed * delta;
		anim.walk()
	else:
		anim.idle()

func damaged(damage: float) -> void:
	enemy_health -= damage;
	hp_bar.value = enemy_health

	if enemy_health <= 0:
		var item = zombie_data.drop_count_ratio[randi() % zombie_data.drop_count_ratio.size()]
		
		queue_free()
		for i in range(item):
			var base_dir = global_position.direction_to(player.global_position)

			# Add small random angle so drops don't overlap
			var random_angle = randf_range(-0.5, 0.5)   # ~±30°
			var final_dir = base_dir.rotated(random_angle)
			var distance = randf_range(60, 100)          # how far to throw
			
			var drops := DROPS.instantiate()
			drops.global_position = self.global_position + final_dir * distance
			get_tree().current_scene.call_deferred("add_child",drops)
		
		ResourceManager.enemy_list.erase(self)
