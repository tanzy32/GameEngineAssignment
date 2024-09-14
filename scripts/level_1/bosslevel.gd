extends BaseScene

var slime_scene: PackedScene = load("res://scenes/levels/level_1/slime.tscn")
@onready var boss_slime = $Boss
@onready var slime = slime_scene.instantiate()
@onready var level_background: TileMap = $"Level background"
	
func _process(delta):
	if boss_slime.get_children().is_empty():
		entrance_markers.visible = true
	else:
		entrance_markers.visible = false
	
func _ready() -> void:
	BackgroundMusicMain.stop()
	super()
	boss_slime.add_child(slime)
	
	slime.scale = Vector2(5,5)
	slime.position = Vector2(990,-34)
	slime.current_health = 6
	slime.max_health = 6
	
	playerui.get_child(3).setMaxHearts(player.maxHealth)
	playerui.get_child(3).updateHearts(player.currentHealth)
	player.healthChanged.connect(playerui.get_child(3).updateHearts)

