extends Area2D

var is_door_open = false 

func _ready():
	# Assuming the door has a child Area2D for detecting when the player is near
	$Area2D.connect("body_entered", Callable(self, "_on_area_2d_body_entered"))

func _on_button_is_active():
	$AnimationPlayer.play("open_door")
	is_door_open = true  # Mark the door as open
	

func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and is_door_open:
		# Replace "res://path_to_new_scene.tscn" with the actual path to the new scene
		get_tree().change_scene_to_file("res://scenes/levels/level_2/bosslevel_2.tscn")



