extends Node

signal zombieDead

var enemy_spawner : bool= false;
var inside_safe_house: bool = false;

@warning_ignore("unused_signal")
signal craft_building(building: Building)
