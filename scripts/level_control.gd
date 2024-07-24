extends Node2D

var slime_scene: PackedScene = load("res://scenes/levels/level_1/slime.tscn")
@onready var level_timer = $Player/countdown/level_timer
@onready var spawner_timer = $Player/countdown/spawner_timer
@onready var level_background: TileMap = $"Level background"
@onready var countdown: Camera2D = $Player/countdown


func _on_spawner_timer_timeout():
	var slime = slime_scene.instantiate()
	$Enemies.add_child(slime)
		
		
func _process(delta):
	if level_timer.is_stopped():
		spawner_timer.stop()
		
		
func _ready() -> void:
	var used := level_background.get_used_rect()
	var tile_size := level_background.tile_set.tile_size
	
	countdown.limit_top = used.position.y * tile_size.y
	countdown.limit_right = used.end.x * tile_size.x
	countdown.limit_bottom = used.end.y * tile_size.y
	countdown.limit_left = used.position.x * tile_size.x
	countdown.reset_smoothing()
		
		


