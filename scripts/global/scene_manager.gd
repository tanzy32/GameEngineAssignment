class_name SceneManager extends Node

var player: MyPlayer
var scene_dir_path = "res://scenes/levels/level_1/"
var last_scene_name: String

func change_scene(from, to_scene_name:String) -> void:
	last_scene_name = from.name
	print(last_scene_name)
	player = from.player
	player.get_parent().remove_child(player)
	
	var full_path = scene_dir_path + to_scene_name + ".tscn"
	from.get_tree().call_deferred("change_scene_to_file", full_path)
	
