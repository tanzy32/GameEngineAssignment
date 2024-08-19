class_name SceneTrigger extends Area2D

@export var connected_scene: String
var scene_folder = "res://scenes/levels/level_1/"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	var full_path = scene_folder + connected_scene + ".tscn" # Replace with function body.
	var scene_tree = get_tree()
	scene_tree.change_scene_to_file(full_path)
