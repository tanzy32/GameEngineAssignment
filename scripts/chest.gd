extends StaticBody2D
var is_open = false
@onready var interaction_area = $InteractionArea
@onready var sprite = $AnimatedSprite

func _ready():
	interaction_area.interact = Callable(self,"_open_chest")

func _open_chest():
	if not is_open:
		sprite.play("open")
		is_open = true
	
