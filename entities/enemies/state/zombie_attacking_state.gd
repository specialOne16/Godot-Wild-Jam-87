extends ZombieBaseState
class_name ZombieAttackingState

@onready var zombie_range: Area2D = %ZombieRange
@onready var zombie_idle_state: ZombieIdleState = $"../ZombieIdleState"

func enter() -> void:
	enemy.linear_velocity = Vector2.ZERO
	
	await enemy.anim.attack()
	for body in zombie_range.get_overlapping_bodies():
		if body is Player:
			body.damaged(enemy.data.zombie_damage)
	
	finished.emit(zombie_idle_state)
