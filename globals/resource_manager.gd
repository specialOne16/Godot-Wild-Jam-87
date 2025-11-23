extends Node

signal wood_changed(new_value: int)
signal stone_changed(new_value: int)
signal steel_changed(new_value: int)

var current_wood: int = 0 :
	get:
		return(current_wood)
	set(value):
		current_wood = value
		wood_changed.emit(value)

var current_stone: int = 0 :
	get:
		return(current_stone)
	set(value):
		current_stone = value
		stone_changed.emit(value)

var current_steel: int = 0 :
	get:
		return(current_steel)
	set(value):
		current_steel = value
		steel_changed.emit(value)

var enemy_list: Array
var player_upgrade: Array =['wood','wood','wood','wood','wood','stone','stone','stone','steel','steel', 'hp','hp','hp','hp','damage','damage']
