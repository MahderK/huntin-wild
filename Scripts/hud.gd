extends CanvasLayer

@onready var label = $Clock
@onready var timer = $Timer
@onready var sun_label = $Pickup/SunCounter
@onready var tot_time_in_sec : int = 190

signal time_change(total_seconds)

func _ready():
	GameManager.sun_changed.connect(_on_sun_changed)
	_on_sun_changed(GameManager.sun_count)
	$Timer.start()

func _on_sun_changed(new_amount):
	sun_label.text = str(new_amount)

func _on_timer_timeout() -> void:
	tot_time_in_sec += 1
	var hour = float(tot_time_in_sec/ 10)
	var minute = (tot_time_in_sec % 10) * 6

	$Clock.text = '%02d: %02d' % [int(hour), int(minute)]

	time_change.emit(tot_time_in_sec)

	if tot_time_in_sec >= 240:
		tot_time_in_sec = 0
