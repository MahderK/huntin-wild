extends CharacterBody2D
class_name Player

@export var speed = 400
@onready var display_equipment = $Equipment
@onready var muzzle = $GunMuzzle
@onready var raycast = $GunMuzzle/RayCast2D
@onready var sfx_shotgun = $GunMuzzle/AudioStreamPlayer

func get_input():

	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

	if Input.is_action_just_pressed("cycle_tool_up"):
		GameManager.current_tool = (GameManager.current_tool + 1) % GameManager.Tools.size()
		print("Equiped seed: ", GameManager.Tools.keys()[GameManager.current_tool])

	if Input.is_action_just_pressed("cycle_tool_down"):
		GameManager.current_tool = (GameManager.current_tool - 1 + GameManager.Tools.size()) % GameManager.Tools.size()
		print("Equiped seed: ", GameManager.Tools.keys()[GameManager.current_tool])

	update_display()

func update_display():
	for i in display_equipment.get_child_count():
		var child = display_equipment.get_child(i)
		if i == GameManager.current_tool:
			child.visible = true
		else:
			child.visible = false


func _physics_process(delta):
	get_input()
	move_and_slide()

	if velocity.length() > 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk_side"
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y > 0:
		$AnimatedSprite2D.animation = "walk_front"
	elif velocity.y < 0:
		$AnimatedSprite2D.animation = "walk_back"

	if GameManager.is_night:
		display_equipment.visible = false

		if Input.is_action_just_pressed("shoot"):
			shoot_shotgun()
	else:
		display_equipment.visible = true

	muzzle.look_at(get_global_mouse_position())

func shoot_shotgun():
	sfx_shotgun.play()
	raycast.target_position.x = GameManager.shotgun_reach


	if raycast.is_colliding():
		var target = raycast.get_collider()
		if target.has_method("take_damage"):
			target.take_damage(50)

# Player.gd

func _ready():
    # Reset health when the game starts
	GameManager.current_health = GameManager.max_health

func take_damage(amount: int):
	GameManager.current_health -= amount
	GameManager.health_changed.emit(GameManager.current_health)
    
    # Visual feedback: Flash red
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate", Color.RED, 0.1)
	tween.tween_property($AnimatedSprite2D, "modulate", Color.WHITE, 0.1)
    
	if GameManager.current_health <= 0:
		die()

func die():
	print("Game Over!")
	get_tree().reload_current_scene() # Simple reset for now