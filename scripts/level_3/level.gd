extends Node2D

@onready var player: MyPlayer = $Player
@onready var playerui = player.get_child(-1)
@onready var level_background: TileMap = $"Level Background"

var player_nearby: bool = false 
var is_activate_waterlever: bool = false
var is_activate_platformlever: bool = false

func _ready():
	BackgroundMusicMain.stop()
	var used := level_background.get_used_rect()
	var tile_size := level_background.tile_set.tile_size
	
	playerui.get_child(3).setMaxHearts(player.maxHealth)
	playerui.get_child(3).updateHearts(player.currentHealth)
	player.healthChanged.connect(playerui.get_child(3).updateHearts)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

