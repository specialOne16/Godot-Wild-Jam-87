extends Control
class_name DayNightCycle

@onready var dark_overlay: Panel = $DarkOverlay
@onready var cycle_timer: Timer = $CycleTimer

func _ready() -> void:
	dark_overlay.visible = false
	
	cycle_timer.start()
	cycle_timer.timeout.connect(toggle_dark_overlay)

func toggle_dark_overlay():
	dark_overlay.visible = not dark_overlay.visible
