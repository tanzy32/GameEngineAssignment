extends CanvasLayer

@onready var game_over_ui = $"."



# Called when the node enters the scene tree for the first time.
func _ready():
	game_over_ui.visible = false
	#get_tree().paused = true

func _input(event):
	# Check if the game over UI is visible
	if game_over_ui.visible:
		# Ignore the input actions if the game over UI is visible
		if event.is_action_pressed("pause") or event.is_action_pressed("ui_cancel"):
			return
	
	# Handle other inputs when game over UI is not visible
	if event.is_action_pressed("pause"):
		# Handle pause action
		pass

	if event.is_action_pressed("ui_cancel"):
		# Handle UI cancel action
		pass


func _on_main_menu_texture_button_pressed():
	$Click.play()
	await $Click.finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")


func _on_main_menu_texture_button_focus_entered():
	$Hover.play()


func _on_restart_texture_button_pressed():
	$Click.play()
	await $Click.finished
	get_tree().reload_current_scene()


func _on_restart_texture_button_focus_entered():
	$Hover.play()
