extends Control

@onready var start_button = $VBoxContainer2/StartButton


# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_1/level.tscn")

	
func _on_load_data_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/load_data.tscn")
	
func _on_levels_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/select_levels.tscn")

func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/settings.tscn")
	
func _on_achievement_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/achievements.tscn")

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/credits.tscn")
	
func _on_quit_button_pressed():
	get_tree().quit()















