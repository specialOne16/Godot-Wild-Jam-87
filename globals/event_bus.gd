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
