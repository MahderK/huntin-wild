extends CharacterBody2D

@export var speed = 400
@onready var display_equipment = $Equipment

enum Tools {STRAWBERRY, LEAK, POTATO, ONION, SHOVEL}
var current_tool = Tools.STRAWBERRY

func get_input():

	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

	if Input.is_action_just_pressed("cycle_tool_up"):
		current_tool = (current_tool + 1) % Tools.size()
		print("Equiped seed: ", Tools.keys()[current_tool])

	if Input.is_action_just_pressed("cycle_tool_down"):
		current_tool = (current_tool - 1 + Tools.size()) % Tools.size()
		print("Equiped seed: ", Tools.keys()[current_tool])

	update_display()

func update_display():
	for i in display_equipment.get_child_count():
		var child = display_equipment.get_child(i)
		if i == current_tool:
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