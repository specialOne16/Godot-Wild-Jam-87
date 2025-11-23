extends ZombieBaseState
class_name ZombieRangedAttackingState

const BULLET = preload("uid://c0xqahtmvo8kf")
const BULLET_THIN = preload("uid://06r85jy7uf4e")

@onready var zombie_idle_state: ZombieIdleState = $"../ZombieIdleState"
@onready var nozzle: Node2D = $"../../Nozzle"

func enter() -> void:
	enemy.linear_velocity = Vector2.ZERO
	enemy.anim.impact.connect(shot_bullet)
	await enemy.anim.attack()
	
	finished.emit(zombie_idle_state)

func exit() -> void:
	enemy.anim.impact.disconnect(shot_bullet)

func shot_bullet():
	if not is_active: return
	
	var bullet: Bullet = BULLET.instantiate()
	bullet.direction = enemy.global_position.direction_to(enemy.player.global_position)
	bullet.global_position = nozzle.global_position
	bullet.damage = enemy.data.zombie_damage
	bullet.texture = BULLET_THIN
	bullet.set_collision_mask_value(1, true)
	get_tree().current_scene.call_deferred("add_child",bullet)
