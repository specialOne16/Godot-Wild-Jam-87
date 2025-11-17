extends Node

signal wood_changed(new_value: int)

var current_wood: int = 0

func gain_wood():
	current_wood += 1
	wood_changed.emit(current_wood)
