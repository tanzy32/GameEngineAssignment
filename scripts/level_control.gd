extends Node2D

var slime_scene: PackedScene = load("res://scenes/levels/level_1/slime.tscn")
@onready var level_timer = $Player/countdown/level_timer
@onready var spawner_timer = $Player/countdown/spawner_timer



func _on_spawner_timer_timeout():
	var slime = slime_scene.instantiate()
	$Enemies.add_child(slime)
	

			
func _process(delta):
	if level_timer.is_stopped():
		spawner_timer.stop()
		
		
		
		


