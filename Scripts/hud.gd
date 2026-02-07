extends CanvasLayer

@onready var label = $Clock
@onready var timer = $Timer
@onready var tot_time_in_sec : int = 890

signal time_change(total_seconds)

func _ready():
	$Timer.start()



func _on_timer_timeout() -> void:
	tot_time_in_sec += 1
	var hour = float(tot_time_in_sec/ 50)
	var minute = (tot_time_in_sec % 50) * 1.2

	$Clock.text = '%02d: %02d' % [hour, minute]

	time_change.emit(tot_time_in_sec)

	if tot_time_in_sec >= 1199:
		tot_time_in_sec = 0
