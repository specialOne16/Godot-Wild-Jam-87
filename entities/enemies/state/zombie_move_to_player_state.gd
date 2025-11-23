extends ZombieBaseState
class_name ZombieMoveToPlayerState

@onready var zombie_idle_state: ZombieIdleState = $"../ZombieIdleState"
@onready var zombie_melee_attacking_state: ZombieMeleeAttackingState = $"../ZombieMeleeAttackingState"
@onready var zombie_ranged_attacking_state: ZombieRangedAttackingState = $"../ZombieRangedAttackingState"
@onready var zombie_start_melee_attack_range: Area2D = %ZombieStartMeleeAttackRange
@onready var zombie_ranged_attack_range: Area2D = %ZombieRangedAttackRange

var move_speed = 100.0

func enter() -> void:
	enemy.anim.walk()

func physics_process(_delta: float) -> void:
	# TODO : when day arrives need to either stop zombies attacking player.
	if enemy.player:
		enemy.linear_velocity = enemy.position.direction_to(enemy.player.position) * enemy.data.move_speed
	else:
		finished.emit(zombie_idle_state)
	
	if enemy.data.is_melee:
		for body in zombie_start_melee_attack_range.get_overlapping_bodies():
			if body.has_method("damaged"):
				finished.emit(zombie_melee_attacking_state)
	else:
		for body in zombie_ranged_attack_range.get_overlapping_bodies():
			if body is Player:
				finished.emit(zombie_ranged_attacking_state)
				return
		
		for body in zombie_start_melee_attack_range.get_overlapping_bodies():
			if body.has_method("damaged"):
				finished.emit(zombie_ranged_attacking_state)
		
