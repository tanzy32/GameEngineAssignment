class_name BaseScene_3 extends Node2D

@onready var player: MyPlayer = $Player
@onready var entrance_markers: Area2D = $PortalEntrance
@onready var playerui = player.get_child(-1)

var has_last_scene: bool = false

func _ready():
	if SceneManagerLoad.player:
		if player:
			player.queue_free()
			
		player = SceneManagerLoad.player
		add_child(player)
		
	position_player()
	
func position_player()->void:
	var last_scene = SceneManagerLoad.last_scene_name
	
	if last_scene.is_empty():
		has_last_scene = false
	else:
		has_last_scene = true
		
	for entrance in entrance_markers.get_children():
		if entrance is Marker2D and last_scene:
			player.global_position = entrance.global_position
