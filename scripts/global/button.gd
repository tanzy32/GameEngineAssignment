extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed_retry():
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/levels/level_1/level.tscn")


func _on_pressed_quit():
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
