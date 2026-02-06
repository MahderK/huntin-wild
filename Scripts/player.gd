extends CharacterBody2D

@export var speed = 400

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

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