extends ZombieBaseState
class_name ZombieMeleeAttackingState

@onready var zombie_melee_attack_range: Area2D = %ZombieMeleeAttackRange
@onready var zombie_idle_state: ZombieIdleState = $"../ZombieIdleState"

func enter() -> void:
	enemy.anim.impact.connect(deal_damage)
	await enemy.anim.attack()
	
	finished.emit(zombie_idle_state)

func process(_delta: float) -> void:
	if enemy.player:
		enemy.linear_velocity = enemy.position.direction_to(enemy.player.position) * enemy.data.move_speed / 3
	else:
		finished.emit(zombie_idle_state)

func exit() -> void:
	enemy.anim.impact.disconnect(deal_damage)

func deal_damage():
	if not is_active: return
	
	for body in zombie_melee_attack_range.get_overlapping_bodies():
		if body is Player:
			body.damaged(enemy.data.zombie_damage)
