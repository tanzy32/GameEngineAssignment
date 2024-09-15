extends Area2D
var is_activate = false

@onready var sprite = $Idle
@onready var animations = $AnimationPlayer
@onready var label = $Label

var player_nearby: bool = false

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	print(sprite.visible)
	animations.play("idle")
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
		$Puzzle.play()
		player_nearby = false
		label.hide()
		animations.play("run")
		activate_puzzle()
		
func activate_puzzle():
	if not is_activate:
		$"../../LevelControls/LevelTimer".start()
		$"../../LevelControls/LevelLabel".show()
		$"../../LevelControls/Spawner".start()
		is_activate = true

	
	
