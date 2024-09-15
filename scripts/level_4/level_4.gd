extends Node2D

@export var level_start_pos : Node2D
@onready var player: MyPlayer = $Player
@onready var playerui = player.get_child(-1)



func _ready() -> void:
	$BGM.play()
	BackgroundMusicMain.stop()
	
	playerui.get_child(3).setMaxHearts(player.maxHealth)
	playerui.get_child(3).updateHearts(player.currentHealth)
	player.healthChanged.connect(playerui.get_child(3).updateHearts)
