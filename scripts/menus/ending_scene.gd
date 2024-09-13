extends Control

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("The End")
	await animation_player.animation_finished
	animation_player.play("ThankYou")
	await animation_player.animation_finished
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
