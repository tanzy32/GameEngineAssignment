extends Area2D


@onready var activator = $Sprite2D
@onready var label = $Label

var player_nearby: bool = false 
var is_activate_waterlever: bool = false
var is_activate_platformlever: bool = false

func _ready():
	label.hide()  # Hide the interaction label initially

func _on_platform_activator_body_entered(body: Node):
	if body is CharacterBody2D:
		is_activate_platformlever = true
		player_nearby = true
		label.show() 

func _on_platform_activator_body_exited(body: Node):
	if body is CharacterBody2D:
		is_activate_platformlever = false
		player_nearby = false
		if is_instance_valid(label): 
			label.hide()
			
func _on_water_activator_body_entered(body: Node):
	if body is CharacterBody2D:
		is_activate_waterlever = true
		player_nearby = true
		label.show() 

func _on_water_activator_body_exited(body: Node):
	if body is CharacterBody2D:
		is_activate_waterlever = false
		player_nearby = false
		if is_instance_valid(label): 
			label.hide()

func _input(event):
	if player_nearby and event.is_action_pressed("interact") and is_activate_platformlever:
		move_platform()
	if player_nearby and event.is_action_pressed("interact") and is_activate_waterlever:
		remove_water()
		
	
func move_platform():
	var platforms = $"../Platforms".get_children()
	for platform in platforms:
		if platform is AnimationPlayer:
			platform.play("move")
	
func remove_water():
	pass
	
