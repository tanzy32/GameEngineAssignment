extends Control

@onready var texture_button = $GridContainer/TextureButton
@onready var texture_button_focused = false


# Called when the node enters the scene tree for the first time.
func _ready():
	texture_button_focused = true
	texture_button.grab_focus()
	call_deferred("_reset_focus_flag")

func _reset_focus_flag():
	texture_button_focused = false

func _on_texture_button_pressed():
	$Click.play()
	await $Click.finished
	get_tree().change_scene_to_file("res://scenes/levels/level_1/level.tscn")
	
func _on_texture_button_focus_entered():
	if texture_button_focused:
		texture_button_focused = false
	else:
		$Hover.play()

func _on_texture_button_2_pressed():
	$Click.play()
	await $Click.finished
	get_tree().change_scene_to_file("res://scenes/levels/level 2/level_2.tscn")
	
func _on_texture_button_2_focus_entered():
	$Hover.play()

func _on_texture_button_3_pressed():
	$Click.play()
	await $Click.finished
	get_tree().change_scene_to_file("res://scenes/levels/level_3/level_3.tscn")
	
func _on_texture_button_3_focus_entered():
	$Hover.play()

func _on_texture_button_4_pressed():
	$Click.play()
	await $Click.finished
	get_tree().change_scene_to_file("res://scenes/levels/level_4.tscn")

func _on_texture_button_4_focus_entered():
	$Hover.play()
