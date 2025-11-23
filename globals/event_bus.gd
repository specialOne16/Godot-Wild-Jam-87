extends Node

@warning_ignore("unused_signal")
signal craft_building(building: Building)

@warning_ignore("unused_signal")
signal zombieDead

@warning_ignore("unused_signal")
signal time_changed(current_time: String)

@warning_ignore("unused_signal")
signal player_died

func restart():
	ResourceManager.current_steel = 0
	ResourceManager.current_wood = 0
	ResourceManager.current_stone = 0
	
	ResourceManager.enemy_list.clear()
	ResourceManager.player_upgrade = ['wood','wood','wood','wood','wood','stone','stone','stone','steel','steel', 'hp','hp','hp','hp','damage','damage']
extends Node

@warning_ignore("unused_signal")
signal craft_building(building: Building)

@warning_ignore("unused_signal")
signal zombieDead

@warning_ignore("unused_signal")
signal time_changed(current_time: String)

@warning_ignore("unused_signal")
#emitted from DayNightCycle and captured at world
signal night_time_decay
