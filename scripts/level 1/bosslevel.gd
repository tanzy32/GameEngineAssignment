extends Node2D

var slime_scene: PackedScene = load("res://scenes/levels/level_1/slime.tscn")
@onready var playerui = $PlayerUI
@onready var player = $Player
@onready var boss_slime = $Boss
@onready var slime = slime_scene.instantiate()
@onready var level_background: TileMap = $"Level background"

var death: int = 0
	
func _process(delta):
	pass
	
func _ready() -> void:
	boss_slime.add_child(slime)
	
	slime.scale = Vector2(4,4)
	slime.position = Vector2(520,243)
	slime.current_health = 6
	slime.max_health = 6
	
	playerui.get_child(3).setMaxHearts(player.maxHealth)
	playerui.get_child(3).updateHearts(player.currentHealth)
	player.healthChanged.connect(playerui.get_child(3).updateHearts)

	
func _on_inventory_gui_closed():
	get_tree().paused = false

func _on_inventory_gui_opened():
	get_tree().paused = true
