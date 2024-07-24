extends Control

@onready var texture_button = $GridContainer/TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	texture_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_1/level.tscn")

func _on_texture_button_2_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level 2/level_2.tscn")

func _on_texture_button_3_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_3.tscn")

func _on_texture_button_4_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_4.tscn")
