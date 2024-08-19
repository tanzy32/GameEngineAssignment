extends BaseScene

@onready var playerui = $PlayerUI
@onready var slimes = $Slimes

var slime_scene: PackedScene = load("res://scenes/levels/level_1/slime.tscn")
@onready var level_timer = $PlayerUI/countdown/level_timer
@onready var spawner_timer = $PlayerUI/countdown/spawner_timer
@onready var level_background: TileMap = $"Level background"
@onready var countdown: Control = $PlayerUI/countdown

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
	super()
	var used := level_background.get_used_rect()
	var tile_size := level_background.tile_set.tile_size
	
	playerui.get_child(3).setMaxHearts(player.maxHealth)
	playerui.get_child(3).updateHearts(player.currentHealth)
	player.healthChanged.connect(playerui.get_child(3).updateHearts)
	
	
func _on_inventory_gui_closed():
	get_tree().paused = false

func _on_inventory_gui_opened():
	get_tree().paused = true
