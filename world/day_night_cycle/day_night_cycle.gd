extends Control
class_name DayNightCycle

@onready var dark_overlay: Panel = $DarkOverlay
@onready var morning_timer: Timer = %MorningTimer
@onready var dusk_overlay: Panel = %DuskOverlay
@onready var dusk_timer: Timer = %DuskTimer
@onready var night_timer: Timer = %NightTimer

@export var morning_timer_time : float = 2
@export var dusk_timer_time : float = 2
@export var night_timer_time : float = 2

func _ready() -> void:
	dark_overlay.visible = false
	dark_overlay.visible = false
	timer_init()
	toggle_morning_overlay()
	#cycle_timer.start()
	#cycle_timer.timeout.connect(toggle_morning_overlay)

func timer_init():
	morning_timer.wait_time = morning_timer_time
	dusk_timer.wait_time = dusk_timer_time
	night_timer.wait_time = night_timer_time
	morning_timer.timeout.connect(toggle_dusk_overlay)
	dusk_timer.timeout.connect(toggle_dark_overlay)
	night_timer.timeout.connect(toggle_morning_overlay)

func toggle_morning_overlay():
	event_bus.enemy_spawner = false
	dusk_overlay.visible = false
	dark_overlay.visible = false
	morning_timer.start()

func toggle_dusk_overlay():
	dusk_overlay.visible = not dusk_overlay.visible
	dusk_timer.start()

func toggle_dark_overlay():
	dark_overlay.visible = not dark_overlay.visible
	event_bus.enemy_spawner = true
	night_timer.start()
	
