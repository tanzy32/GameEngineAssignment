extends Control

@onready var label = $level_description
@onready var timer = $level_timer

func _ready():
	label.hide()

func time_countdown():
	var time_left = timer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute,second]
	
func _process(delta):
	label.text = "%02d:%02d | Survive!" % time_countdown() 
	if timer.is_stopped():
		label.hide()

	
