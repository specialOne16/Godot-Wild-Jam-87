extends ZombieBaseState
class_name ZombieMoveToPlayerState

@onready var zombie_idle_state: ZombieIdleState = $"../ZombieIdleState"
@onready var zombie_attacking_state: ZombieAttackingState = $"../ZombieAttackingState"
@onready var zombie_range: Area2D = %ZombieRange

var move_speed = 100.0

func enter() -> void:
	enemy.anim.walk()

func physics_process(_delta: float) -> void:
	# TODO : when day arrives need to either stop zombies attacking player.
	if enemy.player:
		enemy.linear_velocity = enemy.position.direction_to(enemy.player.position) * move_speed
	else:
		finished.emit(zombie_idle_state)
	
	for body in zombie_range.get_overlapping_bodies():
		if body is Player:
			finished.emit(zombie_attacking_state)
