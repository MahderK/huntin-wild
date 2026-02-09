extends Node2D

@onready var ground = $Ground
@onready var crop_layer = $Crop

var crop : Dictionary = {}

@export var block : Dictionary[String, BlockData]
@export var sun_scene : PackedScene

func _physics_process(delta: float) -> void:

	for pos in crop:

		if crop[pos]["duration"] == -INF:
			if not crop[pos].has("sun_spawned"):
				spawn_sun(pos)
				crop[pos]["sun_spawned"] = true
			continue

		crop[pos]["duration"] += delta

		var duration = crop[pos]["duration"]
		var crop_name = crop[pos]["name"]

		if duration >= block[crop_name].duration:
			set_tile(crop_name, pos, crop_layer, block[crop_name].atlas_coords.size() - 1)
			crop[pos]["duration"] = -INF

		elif duration > 0:
			var index = block[crop_name].growth_index(duration)
			set_tile(crop_name, pos, crop_layer, index)

func _input(event: InputEvent) -> void:

	if GameManager.is_night:
		return

	var currently_equiped = GameManager.current_tool

	if event is InputEventMouseButton and event.pressed:
		var tile_pos = get_snapped_position(get_global_mouse_position())
		var tool_name = GameManager.Tools.keys()[currently_equiped].to_lower()

		if event.button_index == MOUSE_BUTTON_LEFT:
			if crop.has(tile_pos) and crop[tile_pos]["duration"] == -INF:
				crop_layer.set_cell(tile_pos, -1)
				crop.erase(tile_pos)
			var data = ground.get_cell_tile_data(tile_pos)
			if data:
				print(data.get_custom_data("tile_name"))

		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.button_index == MOUSE_BUTTON_RIGHT:
				var data = ground.get_cell_tile_data(tile_pos)
			
				if data and data.get_custom_data("tile_name") == "soil":

					if tool_name == "shovel":
						if crop.has(tile_pos):
							crop_layer.set_cell(tile_pos, -1)
							crop.erase(tile_pos)
							print("Crop removed.")
						else:
							# No crop — remove the tilled soil tile itself
							ground.set_cell(tile_pos, -1)
							print("Soil removed.")
						return

				if not crop.has(tile_pos):
					if block.has(tool_name):
						set_tile(tool_name, tile_pos, crop_layer)
						crop[tile_pos] = {
							"name" : tool_name,
							"duration" : 0
						}
						print("Planted: ", tool_name)
					else:
						print("Error: No BlockData found for ", tool_name)
				else:
					print("Space Occupied!")
			else:
				print("Cannot plant here: Not soil!")

func get_snapped_position(global_pos: Vector2) -> Vector2i:
	var local_pos = ground.to_local(global_pos)
	var tile_pos = ground.local_to_map(local_pos)
	return tile_pos

func set_tile(tile_name: String, cell_pos: Vector2i, layer : TileMapLayer, coord : int = 0):
	if block.has(tile_name):
		layer.set_cell(cell_pos, block[tile_name].source_id, block[tile_name].atlas_coords[coord])

func spawn_sun(tile_pos: Vector2i):
	var sun = sun_scene.instantiate()
    # Convert tile coordinates back to world coordinates
	var spawn_pos = ground.map_to_local(tile_pos) 
	sun.global_position = spawn_pos
	add_child(sun)