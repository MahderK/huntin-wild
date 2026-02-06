extends Sprite2D

func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	look_at(mouse_position)

	if mouse_position.x < global_position.x:
		flip_v = true
	else:
		flip_v = false
