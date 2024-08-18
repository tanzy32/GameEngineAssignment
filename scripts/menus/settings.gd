extends Control

@onready var w_indow_size_option_button = $TitleVBoxContainer/TextureRect/ScrollContainer/VBoxContainer/VideoVBoxContainer/WindowSizeHBoxContainer/WIndowSizeOptionButton
@onready var resolution_option_button = $TitleVBoxContainer/TextureRect/ScrollContainer/VBoxContainer/VideoVBoxContainer/ResolutionHBoxContainer/ResolutionOptionButton
@onready var MASTER_BUS_ID = AudioServer.get_bus_index("Master")
@onready var BGM_BUS_ID = AudioServer.get_bus_index("Music")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")

# Called when the node enters the scene tree for the first time.
func _ready():
	w_indow_size_option_button.item_selected.connect(_on_w_indow_size_option_button_item_selected)
	resolution_option_button.item_selected.connect(_on_resolution_option_button_item_selected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


 

func _on_resolution_option_button_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1280, 720))
		3:
			DisplayServer.window_set_size(Vector2i(1152, 648))


func _on_w_indow_size_option_button_item_selected(index):
	match index:
		0:  # Windowed
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1:  # Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:  # Borderless Window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)




func _on_master_slider_value_changed(value):
	AudioServer.set_bus_volume_db(MASTER_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MASTER_BUS_ID, value < .05)

func _on_bgm_slider_value_changed(value):
	AudioServer.set_bus_volume_db(BGM_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(BGM_BUS_ID, value < .05)

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(BGM_BUS_ID, value < .05)
