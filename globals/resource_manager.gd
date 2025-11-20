extends Node

signal wood_changed(new_value: int)
signal stone_changed(new_value: int)
signal steel_changed(new_value: int)

var current_wood: int = 0 :
	set(value):
		current_wood = value
		wood_changed.emit(value)

var current_stone: int = 0 :
	set(value):
		current_stone = value
		stone_changed.emit(value)

var current_steel: int = 0 :
	set(value):
		current_steel = value
		steel_changed.emit(value)

const player_data_rm : PlayerData = preload("uid://b6otg17jy1a75") as PlayerData
const zombie_data_rm : ZombieData = preload("uid://dd6b64bybbe8m") as ZombieData


var enemy_list: Array
