extends Node2D

@export var day_night_gradient: Gradient
@onready var modulate_node = $CanvasModulate
@onready var audio_player = $bg_music
@onready var equipment = $Player/Equipment
@onready var shotgun = $Player/Weapon

var battle_music = preload("res://Assets/music/🪕 Banjo Bloodbath🩸 ｜ Appalachian Anarchy ｜ 🪕 Bluegrass Power Metal 🤘 - Appalachian Anarchy.mp3")
var day_music = preload("res://Assets/music/Slow Banjo from the heart 🪕♥️ - Slow Banjo.mp3")

func _on_hud_time_change(total_seconds:Variant) -> void:
	var progress = float(total_seconds) / 240.0
	var final_color = day_night_gradient.sample(progress)
	modulate_node.color = final_color
	var music_track : AudioStream

	if total_seconds >= 200:
		equipment.visible = false
		shotgun.visible = true
		music_track = battle_music
		GameManager.is_night = true
	else:
		equipment.visible = true
		shotgun.visible = false
		music_track = day_music
		GameManager.is_night = false

	if audio_player.stream == music_track:
		return

	audio_player.stream = music_track
	audio_player.play()
