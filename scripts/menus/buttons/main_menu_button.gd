extends TextureButton

@onready var hover = $"../Hover"
@onready var click = $"../Click"

func _on_pressed():
	click.play()
	await click.finished
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
	
func _on_focus_entered():
	hover.play()
	


