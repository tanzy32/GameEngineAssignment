extends Area2D

@export var target_scene_path: String = "res://scenes/levels/level_4/level_4_boss_room.tscn"  # Set the target scene path to your desired scene

func _ready():
	# Connect the "body_entered" signal to the function that handles the scene change using a Callablc
	connect("body_entered", Callable(self, "_on_transition_area_body_entered"))

func _on_transition_area_body_entered(body):
	# Check if the body that entered the area is the player
	if body.name == "Player":  # Replace "Player" with the exact name of your player node
		change_scene()

func change_scene():
	# Load the target scene
	var new_scene = load(target_scene_path)
	if new_scene:
		# Get the current scene
		var current_scene = get_tree().current_scene
		
		# Remove the current scene
		get_tree().get_root().remove_child(current_scene)
		current_scene.queue_free()

		# Add the new scene to the scene tree
		get_tree().get_root().add_child(new_scene)
		get_tree().current_scene = new_scene
	else:
		print("Failed to load the target scene: " + target_scene_path)
