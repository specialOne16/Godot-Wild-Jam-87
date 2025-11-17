extends Node

signal wood_changed(new_value: int)

var current_wood: int = 0
var player_weapon_damage: float = 10

func gain_wood(amount: int = 1):
	current_wood += amount
	wood_changed.emit(current_wood)

func spend_wood(amount: int):
	current_wood -= amount
	wood_changed.emit(current_wood)
