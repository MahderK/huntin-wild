extends Node2D

@export var day_night_gradient: Gradient
@onready var modulate_node = $CanvasModulate
@onready var audio_player = $bg_music

var battle_music = preload("res://Assets/music/🪕 Banjo Bloodbath🩸 ｜ Appalachian Anarchy ｜ 🪕 Bluegrass Power Metal 🤘 - Appalachian Anarchy.mp3")
var day_music = preload("res://Assets/music/Slow Banjo from the heart 🪕♥️ - Slow Banjo.mp3")

func _on_hud_time_change(total_seconds:Variant) -> void:
	var progress = float(total_seconds) / 1000.0
	var final_color = day_night_gradient.sample(progress)
	modulate_node.color = final_color
	var music_track : AudioStream

	if total_seconds >= 900:
		music_track = battle_music
	else:
		music_track = day_music

	if audio_player.stream == music_track:
		return

	audio_player.stream = music_track
	audio_player.play()
