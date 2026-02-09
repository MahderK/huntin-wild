extends Node2D

@export var enemy_scene: PackedScene
@onready var spawn_timer = $Timer

func _ready():
	# FIX: In Godot 4, just pass the function name directly.
	if spawn_timer:
		spawn_timer.timeout.connect(_on_timer_timeout)

func _process(_delta):
	# Only manage timer if it's night and not already running
	if GameManager.is_night:
		if spawn_timer.is_stopped():
			spawn_timer.start()
	else:
		if not spawn_timer.is_stopped():
			spawn_timer.stop()

func _on_timer_timeout():
	if not enemy_scene:
		print("Error: No enemy scene assigned to spawner!")
		return
		
	var enemy = enemy_scene.instantiate()
	
	# Spawn logic
	var random_angle = randf() * TAU
	var spawn_dist = 600 

	# Look for player in the group (safer than get_node)
	var player = get_tree().get_first_node_in_group("player")
	
	if player:
		enemy.global_position = player.global_position + Vector2.RIGHT.rotated(random_angle) * spawn_dist
	else:
		enemy.global_position = global_position + Vector2.RIGHT.rotated(random_angle) * spawn_dist
	
	# Add to the main scene (get_parent is usually the World/Main node)
	get_parent().add_child(enemy)
