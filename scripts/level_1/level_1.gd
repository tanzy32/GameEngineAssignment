extends BaseScene

@onready var slimes = $Slimes

var slime_scene: PackedScene = load("res://scenes/levels/level_1/slime.tscn")
@onready var level_timer = $LevelControls/LevelTimer
@onready var label = $LevelControls/LevelLabel
@onready var spawner_timer = $LevelControls/Spawner
@onready var level_background: TileMap = $LevelStructure


func activate_puzzle(is_activate: bool):
	if not is_activate:
		label.show()
		level_timer.start()
		spawner_timer.start()
		is_activate = true
	
func time_countdown():
	var time_left = level_timer.time_left
	var minute = floor(time_left / 60)
	var second = int(time_left) % 60
	return [minute,second]

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
	label.text = "%02d:%02d | Survive!" % time_countdown() 
	if level_timer.is_stopped():
		spawner_timer.stop()
		label.hide()
		
				
func _ready() -> void:
	BackgroundMusicMain.stop()
	super()
	label.hide()
	var used := level_background.get_used_rect()
	var tile_size := level_background.tile_set.tile_size
	
	playerui.get_child(3).setMaxHearts(player.maxHealth)
	playerui.get_child(3).updateHearts(player.currentHealth)
	player.healthChanged.connect(playerui.get_child(3).updateHearts)
	
	
func _on_level_timer_timeout():
	entrance_markers.visible = true
