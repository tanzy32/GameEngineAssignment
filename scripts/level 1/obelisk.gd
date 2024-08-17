extends StaticBody2D
var is_activate = false

@onready var interaction_area = $InteractionArea
@onready var sprite = $AnimatedSprite
@onready var label = $"../../Player/countdown/level_description" 
@onready var level_timer = $"../../Player/countdown/level_timer"
@onready var spawner_timer = $"../../Player/countdown/spawner_timer"

func _ready():
	interaction_area.interact = Callable(self,"_activate_obelisk")

func _activate_obelisk():
	if not is_activate:
		sprite.play("run")
		label.show()
		level_timer.start()
		spawner_timer.start()
		is_activate = true
	
