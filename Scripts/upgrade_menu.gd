extends CanvasLayer

@onready var sun_label = $Panel/VBoxContainer/HBoxContainer/SunCountLabel

func _ready():
	visible = false # Menu starts hidden

func _input(event):
	if event.is_action_pressed("ui_select"): # Default for Space
		toggle_menu()

func toggle_menu():
	visible = !visible
	get_tree().paused = visible # Pauses enemies and farming while shopping
	if visible:
		update_ui()

func update_ui():
	sun_label.text = str(GameManager.sun_count)

# --- Button Connections ---

func _on_speed_upgrade_pressed():
	if GameManager.sun_count >= 10:
		GameManager.sun_count -= 10
		# Find player and boost speed
		var player = get_tree().get_first_node_in_group("player")
		if player:
			player.speed += 40
		update_ui()

func _on_reach_upgrade_pressed():
	if GameManager.sun_count >= 15:
		GameManager.sun_count -= 15
		GameManager.shotgun_reach += 75.0
		update_ui()

func _on_value_upgrade_pressed():
	if GameManager.sun_count >= 20:
		GameManager.sun_count -= 20
		GameManager.sun_value_multiplier += 1
		update_ui()
