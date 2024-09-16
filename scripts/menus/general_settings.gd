extends Control

@onready var w_indow_size_option_button = $TitleVBoxContainer/TextureRect/ScrollContainer/VBoxContainer/VideoVBoxContainer/WindowSizeHBoxContainer/WIndowSizeOptionButton
@onready var resolution_option_button = $TitleVBoxContainer/TextureRect/ScrollContainer/VBoxContainer/VideoVBoxContainer/ResolutionHBoxContainer/ResolutionOptionButton
@onready var MASTER_BUS_ID = AudioServer.get_bus_index("Master")
@onready var BGM_BUS_ID = AudioServer.get_bus_index("Music")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")


@onready var master_slider = $TitleVBoxContainer/TextureRect/ScrollContainer/VBoxContainer/AudioVBoxContainer/MasterVolumeHBoxContainer/MasterSlider
@onready var bgm_slider = $TitleVBoxContainer/TextureRect/ScrollContainer/VBoxContainer/AudioVBoxContainer/BGMMusicVolumeHBoxContainer/BGMSlider
@onready var sfx_slider = $TitleVBoxContainer/TextureRect/ScrollContainer/VBoxContainer/AudioVBoxContainer/SFXVolumeHBoxContainer/SFXSlider

@onready var master_mute_check_box = $TitleVBoxContainer/TextureRect/ScrollContainer/VBoxContainer/AudioVBoxContainer/MasterVolumeHBoxContainer/HBoxContainer/MasterMuteCheckBox
@onready var bgm_mute_check_box = $TitleVBoxContainer/TextureRect/ScrollContainer/VBoxContainer/AudioVBoxContainer/BGMMusicVolumeHBoxContainer/HBoxContainer/BGMMuteCheckBox
@onready var sfx_mute_check_box = $TitleVBoxContainer/TextureRect/ScrollContainer/VBoxContainer/AudioVBoxContainer/SFXVolumeHBoxContainer/HBoxContainer/SFXMuteCheckBox


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


var master_previous_slider_value = 0.0 
var bgm_previous_slider_value = 0.0 
var sfx_previous_slider_value = 0.0 

func _on_master_slider_value_changed(value):
	if value > 0.05:
		if AudioServer.is_bus_mute(MASTER_BUS_ID):
			AudioServer.set_bus_mute(MASTER_BUS_ID, false)
			master_mute_check_box.button_pressed = false
		AudioServer.set_bus_volume_db(MASTER_BUS_ID, linear_to_db(value))
	else:
		AudioServer.set_bus_mute(MASTER_BUS_ID, true)
		master_mute_check_box.button_pressed = true
	
# master check box
func _on_master_mute_check_box_pressed():
	var is_muted = not AudioServer.is_bus_mute(MASTER_BUS_ID)
	AudioServer.set_bus_mute(MASTER_BUS_ID, is_muted)
	if is_muted:
		# If muting, store the current slider value and set it to zero
		master_previous_slider_value = master_slider.value
		master_slider.value = 0.0
	else:
		# If unmuting, restore the previous slider value
		master_slider.value = master_previous_slider_value
		AudioServer.set_bus_volume_db(MASTER_BUS_ID, linear_to_db(master_previous_slider_value))
		

func _on_bgm_slider_value_changed(value):
	if value > 0.05:
		if AudioServer.is_bus_mute(BGM_BUS_ID):
			AudioServer.set_bus_mute(BGM_BUS_ID, false)
			bgm_mute_check_box.button_pressed = false
		AudioServer.set_bus_volume_db(BGM_BUS_ID, linear_to_db(value))
	else:
		AudioServer.set_bus_mute(BGM_BUS_ID, true)
		bgm_mute_check_box.button_pressed = true
	
func _on_bgm_mute_check_box_pressed():
	var is_muted = not AudioServer.is_bus_mute(BGM_BUS_ID)
	AudioServer.set_bus_mute(BGM_BUS_ID, is_muted)
	if is_muted:
		# If muting, store the current slider value and set it to zero
		bgm_previous_slider_value = bgm_slider.value
		bgm_slider.value = 0.0
	else:
		# If unmuting, restore the previous slider value
		bgm_slider.value = bgm_previous_slider_value
		AudioServer.set_bus_volume_db(BGM_BUS_ID, linear_to_db(bgm_previous_slider_value))

func _on_sfx_slider_value_changed(value):
	if value > 0.05:
		if AudioServer.is_bus_mute(SFX_BUS_ID):
			AudioServer.set_bus_mute(SFX_BUS_ID, false)
			sfx_mute_check_box.button_pressed = false
		AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	else:
		AudioServer.set_bus_mute(SFX_BUS_ID, true)
		sfx_mute_check_box.button_pressed = true

func _on_sfx_mute_check_box_pressed():
	var is_muted = not AudioServer.is_bus_mute(SFX_BUS_ID)
	AudioServer.set_bus_mute(SFX_BUS_ID, is_muted)
	if is_muted:
		# If muting, store the current slider value and set it to zero
		sfx_previous_slider_value = sfx_slider.value
		sfx_slider.value = 0.0
	else:
		# If unmuting, restore the previous slider value
		sfx_slider.value = sfx_previous_slider_value
		AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(sfx_previous_slider_value))



