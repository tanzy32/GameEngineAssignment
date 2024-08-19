extends VBoxContainer

# Declare the containers for expandable content
@onready var video_v_box_container = $VideoVBoxContainer
@onready var audio_v_box_container = $AudioVBoxContainer
@onready var keybind_v_box_container = $KeybindVBoxContainer


# texture buttons
@onready var video_texture_button = $VideoTextureButton
@onready var audio_texture_button = $AudioTextureButton
@onready var keybind_texture_button = $KeybindTextureButton



# Called when the node enters the scene tree for the first time.
func _ready():
	video_texture_button.connect("pressed", _on_video_texture_button_pressed)
	audio_texture_button.connect("pressed", _on_audio_texture_button_pressed)
	keybind_texture_button.connect("pressed", _on_keybind_texture_button_pressed)


@onready var dropdown = $"../../../../Dropdown"



func _on_video_texture_button_pressed():
	# Toggle visibility of the video container
	dropdown.play()
	video_v_box_container.visible = !video_v_box_container.visible

func _on_audio_texture_button_pressed():
	# Toggle visibility of the audio container
	dropdown.play()
	audio_v_box_container.visible = !audio_v_box_container.visible

func _on_keybind_texture_button_pressed():
	# Toggle visibility of the keybinds container
	dropdown.play()
	keybind_v_box_container.visible = not keybind_v_box_container.visible
