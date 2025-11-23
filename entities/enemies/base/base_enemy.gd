extends RigidBody2D
class_name BaseEnemy

@export var player: Player
@export var data: ZombieData

@onready var hp_bar: TextureProgressBar = %enemyHpBar

var enemy_health: float = 100
var anim: BaseAnim

const DROPS = preload("uid://b8v3hshx5sa78")
const PERSPECTIVE_OFFSET = Vector2.UP * 11

func _ready() -> void:
	hp_bar.max_value = data.zombie_health
	enemy_health = data.zombie_health
	
	anim = data.texture.instantiate()
	anim.position = PERSPECTIVE_OFFSET
	add_child(anim)

func zombie_died(body: Node2D):
	return(body)

func damaged(damage: float) -> void:
	enemy_health -= damage;
	hp_bar.value = enemy_health

	if enemy_health <= 0:
		drop_items()
		queue_free()
		ResourceManager.enemy_list.erase(self)

func drop_items():
	var item = data.drop_count_ratio[randi() % data.drop_count_ratio.size()]
	
	for i in range(item):
		var base_dir = global_position.direction_to(player.global_position)
	
		# Add small random angle so drops don't overlap
		var random_angle = randf_range(-0.5, 0.5)   # ~±30°
		var final_dir = base_dir.rotated(random_angle)
		var distance = randf_range(60, 100)          # how far to throw
		
		var drops := DROPS.instantiate()
		drops.global_position = self.global_position + final_dir * distance
		get_tree().current_scene.call_deferred("add_child",drops)

	EventBus.zombieDead.emit(self)
