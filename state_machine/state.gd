class_name State extends Node

@warning_ignore("unused_signal")
signal finished(next_state: State)

var is_active: bool = false

func handle_input(_event: InputEvent) -> void:
	pass

func process(_delta: float) -> void:
	pass

func physics_process(_delta: float) -> void:
	pass

func enter() -> void:
	pass

func exit() -> void:
	pass
