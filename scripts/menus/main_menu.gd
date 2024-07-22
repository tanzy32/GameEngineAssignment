extends Control

@onready var start_button = $ButtonsVBoxContainer/StartTextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.grab_focus()

func _on_start_texture_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func _on_load_data_texture_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/load_data.tscn")

func _on_levels_texture_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/select_levels.tscn")

func _on_settings_texture_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/settings.tscn")

func _on_achievements_texture_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/achievements.tscn")

func _on_credits_texture_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/credits.tscn")

func _on_quit_texture_button_pressed():
	get_tree().quit()
















