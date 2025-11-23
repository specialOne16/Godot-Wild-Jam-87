extends Control
class_name DayNightCycle

@onready var dark_overlay: Panel = $DarkOverlay
@onready var morning_timer: Timer = %MorningTimer
@onready var night_timer: Timer = %NightTimer
@onready var day_label: Label = $DayLabel

@export var morning_timer_time : float = 2
@export var night_timer_time : float = 2

var day_count = 0

func _ready() -> void:
	dark_overlay.visible = false
	timer_init()
	toggle_morning_overlay()

func timer_init():
	morning_timer.wait_time = morning_timer_time
	night_timer.wait_time = night_timer_time
	morning_timer.timeout.connect(toggle_dark_overlay)
	night_timer.timeout.connect(toggle_morning_overlay)
	morning_timer.start()
	night_timer.start()

func toggle_morning_overlay():
	day_count += 1
	day_label.text = "Day %d" % day_count
	
	EventBus.time_changed.emit("DAY")
	dark_overlay.visible = false
	morning_timer.start()

func toggle_dark_overlay():
	EventBus.time_changed.emit("NIGHT")
	dark_overlay.visible = true
	night_timer.start()
