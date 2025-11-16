extends Control
class_name DayNightCycle

@onready var dark_overlay: Panel = $DarkOverlay
@onready var morning_timer: Timer = %MorningTimer
@onready var dusk_overlay: Panel = %DuskOverlay
@onready var dusk_timer: Timer = %DuskTimer
@onready var night_timer: Timer = %NightTimer

func _ready() -> void:
	dark_overlay.visible = false
	dark_overlay.visible = false
	toggle_morning_overlay()
	#cycle_timer.start()
	#cycle_timer.timeout.connect(toggle_morning_overlay)


func toggle_morning_overlay():
	event_bus.enemy_spawner = false
	dusk_overlay.visible = false
	dark_overlay.visible = false
	morning_timer.start()
	morning_timer.timeout.connect(toggle_dusk_overlay)

func toggle_dusk_overlay():
	dusk_overlay.visible = not dusk_overlay.visible
	dusk_timer.start()
	dusk_timer.timeout.connect(toggle_dark_overlay)

func toggle_dark_overlay():
	dark_overlay.visible = not dark_overlay.visible
	event_bus.enemy_spawner = true
	night_timer.start()
	night_timer.timeout.connect(toggle_morning_overlay)
	
