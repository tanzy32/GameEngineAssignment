extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


var current_resolution = Vector2i(1920, 1080)  # Default resolution 

func _on_resolution_option_button_item_selected(index):
	match index:
		0:
			current_resolution = Vector2i(1920, 1080)
		1:
			current_resolution = Vector2i(1600, 900)
		2:
			current_resolution = Vector2i(1280, 720)
		3:
			current_resolution = Vector2i(1152, 648)
			
	#Apply the resolution
	DisplayServer.window_set_size(current_resolution)
	# If fullscreen, ensure the resolution change is applied
	if DisplayServer.window_get_mode() == DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
		DisplayServer.window_set_size(current_resolution)


func _on_w_indow_size_option_button_item_selected(index):
	match index:
		0:  # Windowed
			DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_WINDOWED)
		1:  # Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WindowMode.WINDOW_MODE_FULLSCREEN)
		
