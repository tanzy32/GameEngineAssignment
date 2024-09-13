extends Node2D

@onready var player: MyPlayer = $Player
@onready var playerui = player.get_child(-1)
@onready var level_background: TileMap = $"Level background"

func _ready() -> void:
	playerui.get_child(3).setMaxHearts(player.maxHealth)
	playerui.get_child(3).updateHearts(player.currentHealth)
	player.healthChanged.connect(playerui.get_child(3).updateHearts)
