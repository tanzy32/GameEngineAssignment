extends Control

@onready var canvas_layer = $CanvasLayer
@onready var resume_texture_button = $CanvasLayer/PausePanel/CenterContainer/TextureRect/VBoxContainer/ResumeTextureButton
@onready var resume_texture_button_focused = false

func _ready():
	canvas_layer.visible = false
	resume_texture_button.grab_focus()
	resume_texture_button_focused = true
	call_deferred("_reset_focus_flag")
	get_tree().paused = false  # Ensure game is not paused on scene load

func _reset_focus_flag():
	resume_texture_button_focused = false 

func _input(event):
	if event.is_action_pressed("pause"):
		if canvas_layer.visible:
			# Resume game
			resume_texture_button.grab_focus()
			canvas_layer.visible = false
			get_tree().paused = false
		else:
			# Show pause menu
			resume_texture_button.grab_focus()
			canvas_layer.visible = true
			get_tree().paused = true

func _on_resume_texture_button_pressed():
	$Click.play()
	await $Click.finished
	canvas_layer.visible = false
	get_tree().paused = false

func _on_resume_texture_button_focus_entered():
	if resume_texture_button_focused:
		resume_texture_button_focused = false
	else:
		$Hover.play()

func _on_restart_texture_button_pressed():
	$Click.play()
	await $Click.finished
	get_tree().reload_current_scene()

func _on_restart_texture_button_focus_entered():
	$Hover.play()

func _on_settings_texture_button_pressed():
	$Click.play()
	await $Click.finished
	get_tree().change_scene_to_file("res://scenes/menus/settings.tscn")
	
func _on_settings_texture_button_focus_entered():
	$Hover.play()

func _on_main_menu_texture_button_pressed():
	$Click.play()
	await $Click.finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

func _on_main_menu_texture_button_focus_entered():
	$Hover.play()

