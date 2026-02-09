extends Control

func _ready() -> void:
	hide()
	$AnimationPlayer.play("RESET")

func resume():
	hide()
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")

func pause():
	show()
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func testEsc():
	if Input.is_action_just_pressed("pause") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused == true:
		resume()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_cancel_pressed() -> void:
	resume()

func _process(delta: float) -> void:
	testEsc()
