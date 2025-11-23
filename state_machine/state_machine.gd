class_name StateMachine extends Node

@export var initial_state: State = null
var state: State

func _ready() -> void:
	for state_node: State in find_children("*", "State"):
		state_node.finished.connect(_transition_to_next_state)

	await owner.ready
	state = initial_state if initial_state else get_child(0)
	state.enter()

func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)


func _process(delta: float) -> void:
	state.process(delta)


func _physics_process(delta: float) -> void:
	state.physics_process(delta)


func _transition_to_next_state(target_state: State) -> void:
	state.exit()
	state = target_state
	state.enter()
