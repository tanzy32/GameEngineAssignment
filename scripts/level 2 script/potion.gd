extends Area2D

@onready var label = $Label

func _ready():
	# Set the label's visibility to false initially
	label.visible = false

func _on_PotionArea_body_entered(body):
	if body.name == "player":  # Ensure the player node is named "Player"
		label.visible = true

func _on_PotionArea_body_exited(body):
	if body.name == "player":  # Ensure the player node is named "Player"
		label.visible = false
