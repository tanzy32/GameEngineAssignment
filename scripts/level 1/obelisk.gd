extends StaticBody2D
var is_activate = false

@onready var interaction_area = $InteractionArea
@onready var sprite = $AnimatedSprite
@onready var level_timer = $"../../PlayerUI/level_timer"
@onready var label = $"../../PlayerUI/level_description"
@onready var spawner_timer = $"../../PlayerUI/spawner_timer"

func _ready():
	interaction_area.interact = Callable(self,"_activate_obelisk")

func _activate_obelisk():
	if not is_activate:
		sprite.play("run")
		label.show()
		level_timer.start()
		spawner_timer.start()
		is_activate = true
	
