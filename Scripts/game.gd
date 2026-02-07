extends Node2D

@export var day_night_gradient: Gradient
@onready var modulate_node = $CanvasModulate

func _on_hud_time_change(total_seconds:Variant) -> void:
	var progress = float(total_seconds) / 1000.0
	var final_color = day_night_gradient.sample(progress)
	modulate_node.color = final_color
