class_name SceneManager extends Node

var player: MyPlayer
var scene_dir_path = "res://scenes/levels/"
var last_scene_name: String

func change_scene(from, to_scene_name:String) -> void:
	last_scene_name = from.name
	
	player = from.player
	player.get_parent().remove_child(player)
	
	if from.name == "Level1":
		var full_path = scene_dir_path + "level_1/" + to_scene_name + ".tscn"
		from.get_tree().call_deferred("change_scene_to_file", full_path)
	if from.name == "Level2" or from.name == "BossLevel1":
		var full_path = scene_dir_path + "level_2/" + to_scene_name + ".tscn"
		from.get_tree().call_deferred("change_scene_to_file", full_path)
	if from.name == "Level3" or from.name == "BossLevel2":
		var full_path = scene_dir_path + "level_3/" + to_scene_name + ".tscn"
		from.get_tree().call_deferred("change_scene_to_file", full_path)
	if from.name == "Level4" or from.name == "BossLevel3":
		var full_path = scene_dir_path + "level_4/" + to_scene_name + ".tscn"
		from.get_tree().call_deferred("change_scene_to_file", full_path)
