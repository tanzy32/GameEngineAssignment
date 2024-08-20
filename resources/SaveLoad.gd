extends Node

@export var GameSave:GameSaveFile = GameSaveFile.new()



func SaveGame(SaveFilePath:String)->void:
	var Player:Node2D = get_tree().current_scene.get_node("Player")
	if Player:
		GameSave.SavePlayer.pack(Player)
		GameSave.PlayerPosition = Player.global_position
		Player.free()
	GameSave.SaveScene.pack(get_tree().current_scene)
	ResourceSaver.save(GameSave, SaveFilePath)
	
func LoadGame(SaveFilePath:String)->void:
	GameSave = load(SaveFilePath)
	var tree:SceneTree = get_tree()
	tree.change_scene_to_packed(GameSave.SavedScene)
	var play:Node2D = GameSave.SavePlayer.instantiate()
	await tree.node_added
	get_tree().current_scene.add_child(play)
	play.owner = get_tree().current_scene
	play.global_position = GameSave.PlayerPosition
	
	
