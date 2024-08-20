class_name SceneTrigger extends Area2D

@export var connected_scene: String
@onready var label = $Label

var player_nearby: bool = false 

func _ready():
	label.hide() 
	
func _on_body_entered(body):
	if body is CharacterBody2D:
		player_nearby = true
		label.show()
		
func _input(event):
	if player_nearby and event.is_action_pressed("interact"):
		scene_manager.change_scene(get_owner(), connected_scene)
		
func _on_body_exited(body):
	if body is CharacterBody2D:
		player_nearby = false
		label.hide() # Replace with function body.
