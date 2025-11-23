extends ZombieBaseState
class_name ZombieRangedAttackingState

const BULLET = preload("uid://c0xqahtmvo8kf")

@onready var zombie_idle_state: ZombieIdleState = $"../ZombieIdleState"
@onready var nozzle: Node2D = $"../../Nozzle"

func enter() -> void:
	enemy.anim.impact.connect(shot_bullet)
	await enemy.anim.attack()
	
	finished.emit(zombie_idle_state)

func exit() -> void:
	enemy.anim.impact.disconnect(shot_bullet)

func shot_bullet():
	var bullet: Bullet = BULLET.instantiate()
	bullet.direction = enemy.global_position.direction_to(enemy.player.global_position)
	bullet.global_position = nozzle.global_position
	bullet.damage = enemy.data.zombie_damage
	bullet.set_collision_mask_value(1, true)
	get_tree().current_scene.call_deferred("add_child",bullet)
