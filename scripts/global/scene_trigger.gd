class_name SceneTrigger extends Area2D

@export var connected_scene: String
var scene_folder = "res://scenes/levels/level_1/"

func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func _on_body_entered(body):
	if body is MyPlayer:
		scene_manager.change_scene(get_owner(), connected_scene)
