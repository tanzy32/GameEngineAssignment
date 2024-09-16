extends Control

@onready var start_button = $ButtonsVBoxContainer/StartTextureButton
@onready var start_button_focused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	BackgroundMusicMain.play_bgm()
	$ConfirmationWindow.visible = false
	start_button_focused = true
	start_button.grab_focus()
	call_deferred("_reset_focus_flag")
	


func _reset_focus_flag():
	start_button_focused = false

func _on_start_texture_button_pressed():
	$Click.play()
	await $Click.finished
	get_tree().change_scene_to_file("res://scenes/levels/level_1/level_1.tscn")
	
func _on_start_texture_button_focus_entered():
	if start_button_focused:
		start_button_focused = false
	else:
		$Hover.play()

func _on_load_data_texture_button_pressed():
	$Click.play()
	await $Click.finished
	# Check if the save file exists
	if not SaveLoad.HasSavedData("res://resources/data.tres"):
		$ConfirmationWindow.visible  = true
		return
	else:
		SaveLoad.LoadGame("res://resources/data.tres")
	
	
func _on_load_data_texture_button_focus_entered():
	$Hover.play()

func _on_levels_texture_button_pressed():
	$Click.play()
	await $Click.finished
	get_tree().change_scene_to_file("res://scenes/menus/select_levels.tscn")
	
func _on_levels_texture_button_focus_entered():
	$Hover.play()

func _on_settings_texture_button_pressed():
	$Click.play()
	await $Click.finished
	get_tree().change_scene_to_file("res://scenes/menus/settings.tscn")
	
func _on_settings_texture_button_focus_entered():
	$Hover.play()

func _on_credits_texture_button_pressed():
	$Click.play()
	await $Click.finished
	get_tree().change_scene_to_file("res://scenes/menus/credits.tscn")
	
func _on_credits_texture_button_focus_entered():
	$Hover.play()

func _on_quit_texture_button_pressed():
	$Close.play()
	await $Close.finished
	get_tree().quit()

func _on_quit_texture_button_focus_entered():
	$Hover.play()

func _on_okay_texture_button_pressed():
	$Click.play()
	await $Click.finished
	$ConfirmationWindow.visible = false
