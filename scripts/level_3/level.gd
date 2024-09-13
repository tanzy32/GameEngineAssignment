extends Node2D

@onready var player: MyPlayer = $Player
@onready var playerui = player.get_child(-1)
@onready var bubbleui = player.get_child(-2).get_child(0)
@onready var level_background: TileMap = $"Level Background"
@onready var creatures = $Creatures

var rng := RandomNumberGenerator.new()	
var fish_friendly: PackedScene = load("res://scenes/levels/level_3/fishes.tscn")
var fish_enemy: PackedScene = load("res://scenes/levels/level_3/enemyfish.tscn")
var squid: PackedScene = load("res://scenes/levels/level_3/squid.tscn")
var player_nearby: bool = false 
var is_activate_waterlever: bool = false
var is_activate_platformlever: bool = false
var in_water = false
func _ready():
	BackgroundMusicMain.stop()
	$BGM.play()
	var used := level_background.get_used_rect()
	var tile_size := level_background.tile_set.tile_size
	
	playerui.get_child(3).setMaxHearts(player.maxHealth)
	playerui.get_child(3).updateHearts(player.currentHealth)
	player.healthChanged.connect(playerui.get_child(3).updateHearts)
	
	for i in range(50):
		rng = RandomNumberGenerator.new()
		var number = rng.randi_range(1, 10)
		var fish = fish_friendly.instantiate()
		fish.get_child(0).play("fish" + str(number))
		creatures.add_child(fish)
		var random_x = rng.randi_range(-3712,-320)
		var random_y = rng.randi_range(1376, 1768)
		fish.position = Vector2(random_x, random_y)
		
	for i in range(10):
		var fish = squid.instantiate()
		fish.get_child(0).play("squid")
		creatures.add_child(fish)
		var random_x = rng.randi_range(-3712,-320)
		var random_y = rng.randi_range(1376, 1768)
		fish.position = Vector2(random_x, random_y)
		
		var number = rng.randi_range(1,2)
		fish = fish_enemy.instantiate()
		if number == 1:
			fish.get_child(0).play("angler")
		else:
			fish.get_child(0).play("swordfish")
		creatures.add_child(fish)
		random_x = rng.randi_range(-3712,-320)
		random_y = rng.randi_range(1376, 1768)
		fish.position = Vector2(random_x, random_y)
	

func time_countdown():
	var time_left = $"Level Background/waterlevelhitBox/air".time_left
	return round(time_left)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !in_water:
		$"Level Background/waterlevelhitBox/hitbox".disabled = true
		bubbleui.visible = false
	var bubble = bubbleui.get_child(time_countdown())
	bubble.visible = false
	
func _on_waterlevel_body_entered(body):
	if body is MyPlayer:
		$"Level Background/waterlevelhitBox/hitbox".disabled = true
		bubbleui.visible = true
		var bubbles = bubbleui.get_children()
		for bubble in bubbles:
			bubble.visible = true
		$"Level Background/waterlevelhitBox/air".start()
		in_water = true

func _on_waterlevel_body_exited(body):
	if body is MyPlayer:
		$"Level Background/waterlevelhitBox/air".stop
		in_water = false

func _on_air_timeout():
	$"Level Background/waterlevelhitBox/hitbox".disabled = false
