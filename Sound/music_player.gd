extends Node

@onready var day_music: AudioStreamPlayer = $DayMusic
@onready var death: AudioStreamPlayer = $Death
@onready var night_song: AudioStreamPlayer = $NightSong

func _ready() -> void:
	day_music.finished.connect(func(): day_music.play())
	death.finished.connect(func(): death.play())
	night_song.finished.connect(func(): night_song.play())
