extends Node

@export var GameSave:GameSaveFile = GameSaveFile.new()



func SaveGame(SaveFilePath:String)->void:
	var Player:Node2D = get_tree().current_scene.get_node("playertest")
	if Player:
		GameSave.SavePlayer.pack(Player)
		GameSave.PlayerPosition = Player.global_position
		Player.free()
	GameSave.SaveScene.pack(get_tree().current_scene)
	ResourceSaver.save(GameSave, SaveFilePath)
	
func LoadGame(SaveFilePath:String)->void:
	GameSave = load(SaveFilePath)
	if not GameSave:
		print("Failed to load GameSave from path: " + SaveFilePath)
		return
	var tree:SceneTree = get_tree()
	tree.change_scene_to_packed(GameSave.SaveScene)
	var play:Node2D = GameSave.SavePlayer.instantiate()
	if not play:
		print("Failed to instantiate SavePlayer.")
		return
	await tree.node_added
	get_tree().current_scene.add_child(play)
	#play.owner = get_tree().current_scene
	play.global_position = GameSave.PlayerPosition
	
func HasSavedData(SaveFilePath:String)->bool:
	# Attempt to load the resource from the given path
	var loaded_resource := ResourceLoader.load(SaveFilePath)
	# Check if the resource is valid 
	if loaded_resource:
		return true
	# If loading failed, return false
	return false

	
