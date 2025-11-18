extends Node

signal wood_changed(new_value: int)

var current_wood: int = 0
const player_data_rm : PlayerData = preload("uid://b6otg17jy1a75") as PlayerData
const zombie_data_rm : ZombieData = preload("uid://dd6b64bybbe8m") as ZombieData


var enemy_list: Array

func gain_wood(amount: int = 1):
	current_wood += amount
	wood_changed.emit(current_wood)

func spend_wood(amount: int):
	current_wood -= amount
	wood_changed.emit(current_wood)
