extends Area2D

@export var sun_value: int = 1
@export var float_speed: float = 1.0

func _ready():
	# Optional: Make it pop out with a little bounce when it appears
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)

func _process(delta):
	# Gentle floating animation
	position.y += sin(Time.get_ticks_msec() * 0.002) * float_speed * delta * 60

func _input_event(viewport, event, shape_idx):
	# Detect left mouse click on the Area2D
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		collect_sun()

func collect_sun():
	# Add value to your GameManager
	if "sun_count" in GameManager:
		GameManager.sun_count += ( 1 * GameManager.sun_multiplier)
		print("Collected! Total Sun: ", GameManager.sun_count)
	
	# Play sound or particles here if you have them!
	
	# Animate shrinking before disappearing
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.2)
	tween.finished.connect(queue_free)