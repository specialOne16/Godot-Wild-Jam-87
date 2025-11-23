extends ZombieBaseState
class_name ZombieIdleState

@onready var zombie_move_to_player_state: ZombieMoveToPlayerState = $"../ZombieMoveToPlayerState"

func enter() -> void:
	enemy.anim.idle()

func process(_delta: float) -> void:
	if enemy.player:
		finished.emit(zombie_move_to_player_state)
