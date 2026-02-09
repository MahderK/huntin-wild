extends Node

enum Tools {STRAWBERRY, LEAK, POTATO, ONION, SHOVEL}
var current_tool = Tools.STRAWBERRY

signal sun_changed(new_value)

var sun_count: int = 0:
	set(value):
		sun_count = value
		sun_changed.emit(sun_count) # Tell the world the count changed!

var sun_multiplier : int = 1
var shotgun_reach : float = 150.0
var is_night : bool = false
var max_health: int = 100
var current_health: int = 100
var previous_scene: String = "res://Scenes/main_menu.tscn"

signal health_changed(new_health)
