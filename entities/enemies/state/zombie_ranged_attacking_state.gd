extends ZombieBaseState
class_name ZombieRangedAttackingState

const BULLET = preload("uid://c0xqahtmvo8kf")
const BULLET_THIN = preload("uid://06r85jy7uf4e")

@onready var zombie_ranged_attack_range: Area2D = %ZombieRangedAttackRange
@onready var zombie_idle_state: ZombieIdleState = $"../ZombieIdleState"
@onready var nozzle: Node2D = $"../../Nozzle"

@export var knockback: float = 20

func enter() -> void:
	enemy.linear_velocity = Vector2.ZERO
	enemy.anim.impact.connect(find_target_and_shot)
	await enemy.anim.attack()
	
	finished.emit(zombie_idle_state)

func exit() -> void:
	enemy.anim.impact.disconnect(find_target_and_shot)

func find_target_and_shot():
	if not is_active: return
	
	var player_in_range = zombie_ranged_attack_range.get_overlapping_bodies().any(func(body): return body is Player)
	
	if player_in_range: shot(enemy.player)
	else:
		for body in zombie_ranged_attack_range.get_overlapping_bodies():
			if body.has_method("damaged"):
				shot(body)
				return

func shot(target: Node2D):
	var bullet: Bullet = BULLET.instantiate()
	bullet.direction = enemy.global_position.direction_to(target.global_position)
	bullet.global_position = nozzle.global_position
	bullet.damage = enemy.data.zombie_damage
	bullet.texture = BULLET_THIN
	bullet.set_collision_mask_value(1, true)
	bullet.set_collision_mask_value(4, true)
	bullet.set_collision_mask_value(7, true)
	bullet.set_collision_mask_value(2, false)
	get_tree().current_scene.call_deferred("add_child",bullet)
	
	enemy.apply_impulse(target.global_position.direction_to(enemy.global_position).normalized() * knockback)
