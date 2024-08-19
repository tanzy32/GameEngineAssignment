extends Node2D

@onready var playerui = $PlayerUI
@onready var player = $Player
@onready var slimes = $Slimes

var slime_scene: PackedScene = load("res://scenes/levels/level_1/slime.tscn")
@onready var level_timer = $Player/countdown/level_timer
@onready var spawner_timer = $Player/countdown/spawner_timer
@onready var level_background: TileMap = $"Level background"
@onready var countdown: Camera2D = $Player/countdown

func _on_spawner_timer_timeout():
	var slime = slime_scene.instantiate()
	slimes.add_child(slime)
	var rng = RandomNumberGenerator.new()
	var random_x = rng.randi_range(-640, 800)
	var random_y = rng.randi_range(-1600, -1300)
	slime.position = Vector2(random_x, random_y)
	slime.current_health = 1
	slime.max_health = 1
	
func _process(delta):
	if level_timer.is_stopped():
		spawner_timer.stop()
		
		
func _ready() -> void:
	var used := level_background.get_used_rect()
	var tile_size := level_background.tile_set.tile_size
	
	playerui.get_child(3).setMaxHearts(player.maxHealth)
	playerui.get_child(3).updateHearts(player.currentHealth)
	player.healthChanged.connect(playerui.get_child(3).updateHearts)
	
	
	countdown.limit_top = used.position.y * tile_size.y
	countdown.limit_right = used.end.x * tile_size.x
	countdown.limit_bottom = used.end.y * tile_size.y
	countdown.limit_left = used.position.x * tile_size.x
	countdown.reset_smoothing()
	
func _on_inventory_gui_closed():
	get_tree().paused = false

func _on_inventory_gui_opened():
	get_tree().paused = true
