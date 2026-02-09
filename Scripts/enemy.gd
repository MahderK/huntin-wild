extends CharacterBody2D

@export var speed: float = 120.0
@export var health: int = 100
@export var damage: int = 10
@export var attack_rate: float = 1.0 

@onready var animated_sprite = $AnimatedSprite2D

var attack_timer: float = 0.0

func _physics_process(delta: float) -> void:
	# 1. Day/Night Check
	if not GameManager.is_night:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# 2. Dynamic Player Lookup (Safe & Crash-proof)
	var player = get_tree().get_first_node_in_group("player")

	# If the player is dead or missing, just idle
	if not is_instance_valid(player):
		velocity = Vector2.ZERO
		animated_sprite.stop()
		move_and_slide()
		return

	# 3. Movement and Combat Logic
	var distance = global_position.distance_to(player.global_position)
	var direction = global_position.direction_to(player.global_position)

	if distance < 50:
		# Attack Logic
		velocity = Vector2.ZERO
		attack_timer += delta
		
		if attack_timer >= attack_rate:
			if player.has_method("take_damage"):
				player.take_damage(damage)
			attack_timer = 0.0
		
		animated_sprite.stop() 
	else:
		# Movement Logic
		velocity = direction * speed
		attack_timer = 0.0 
		
		if not animated_sprite.is_playing():
			animated_sprite.play("walk")
	
	# 4. Sprite Flip
	if direction.x != 0:
		animated_sprite.flip_h = direction.x < 0

	move_and_slide()

func take_damage(amount: int):
	health -= amount
	
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.RED, 0.1)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)

	if health <= 0:
		die()

func die():
	queue_free()
