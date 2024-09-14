class_name SceneManager extends Node

var player: MyPlayer
var scene_dir_path = "res://scenes/levels/"
var last_scene_name: String

func change_scene(from, to_scene_name:String) -> void:
	last_scene_name = from.name
	
	player = from.player
	player.get_parent().remove_child(player)
	
	if from.name == "Level 1":
		var full_path = scene_dir_path + "level_1/" + to_scene_name + ".tscn"
		from.get_tree().call_deferred("change_scene_to_file", full_path)
	if from.name == "Level 2" or from.name == "Boss Level 1":
		var full_path = scene_dir_path + "level_2/" + to_scene_name + ".tscn"
		from.get_tree().call_deferred("change_scene_to_file", full_path)
	if from.name == "Level 3" or from.name == "Boss Level 2":
		var full_path = scene_dir_path + "level_3/" + to_scene_name + ".tscn"
		from.get_tree().call_deferred("change_scene_to_file", full_path)
	if from.name == "Level 4" or from.name == "Boss Level 3":
		var full_path = scene_dir_path + "level_4/" + to_scene_name + ".tscn"
		from.get_tree().call_deferred("change_scene_to_file", full_path)
