extends Resource
class_name ZombieData

@export var zombie_health: float = 100.00
@export var zombie_damage: float = 40
@export var move_speed: float = 100
@export var is_melee := true
@export var texture: PackedScene

var drops_list_items: Array =['wood','wood','wood','wood','wood','stone','stone','stone','steel','steel', 'hp','hp','hp','hp','damage','damage']
#var drops_list_player_upgrades: Array =['hp','hp','hp','hp','damage','damage']
var drop_count_ratio: Array = [0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,3,3,4]
