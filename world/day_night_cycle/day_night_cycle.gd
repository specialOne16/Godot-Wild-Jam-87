extends Control
class_name DayNightCycle

@onready var dark_overlay: Panel = $DarkOverlay
@onready var dusk_overlay: Panel = %DuskOverlay
@onready var morning_timer: Timer = %MorningTimer
@onready var dusk_timer: Timer = %DuskTimer
@onready var night_timer: Timer = %NightTimer
@onready var decay_timer: Timer = %DecayTimer

@export var morning_timer_time : float = 2
@export var dusk_timer_time : float = 2
@export var night_timer_time : float = 2
@export var night_time_decay_damage : float = 5

func _ready() -> void:
	dark_overlay.visible = false
	dusk_overlay.visible = false
	timer_init()
	toggle_morning_overlay()

func timer_init():
	morning_timer.wait_time = morning_timer_time
	dusk_timer.wait_time = dusk_timer_time
	night_timer.wait_time = night_timer_time
	morning_timer.timeout.connect(toggle_dusk_overlay)
	dusk_timer.timeout.connect(toggle_dark_overlay)
	night_timer.timeout.connect(toggle_morning_overlay)
	decay_timer.timeout.connect(night_time_decay)

func toggle_morning_overlay():
	EventBus.time_changed.emit("DAY")
	dusk_overlay.visible = false
	dark_overlay.visible = false
	morning_timer.start()
	decay_timer.stop()

func toggle_dusk_overlay():
	EventBus.time_changed.emit("DUSK")
	dusk_overlay.visible = true
	dusk_timer.start()

func toggle_dark_overlay():
	EventBus.time_changed.emit("NIGHT")
	dark_overlay.visible = true
	night_timer.start()
	decay_timer.start()
	
func night_time_decay() -> void:
	EventBus.night_time_decay.emit(night_time_decay_damage)
