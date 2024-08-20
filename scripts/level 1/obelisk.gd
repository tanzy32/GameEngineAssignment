extends Area2D
var is_activate = false

@onready var sprite = $AnimatedSprite
@onready var label = $Label

var player_nearby: bool = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	label.hide()

func _on_body_entered(body: Node):
	if body is CharacterBody2D:
		if !is_activate:
			player_nearby = true
			label.show()

func _on_body_exited(body: Node):
	if body is CharacterBody2D:
		player_nearby = false
		label.hide()
		
func _input(event):
	if player_nearby and event.is_action_pressed("interact"):
		player_nearby = false
		label.hide()
		sprite.play("run")
		activate_puzzle()
		
func activate_puzzle():
	if not is_activate:
		
		$"../../level_controls/level_timer".start()
		$"../../level_controls/level_description".show()
		$"../../level_controls/spawner_timer".start()
		is_activate = true

	
	
