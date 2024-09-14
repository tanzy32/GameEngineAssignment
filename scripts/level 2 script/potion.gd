extends Area2D

@onready var label = $Label

func _ready():
	# Set the label's visibility to false initially
	label.visible = false

func _on_body_entered(body):
	print("body_entered: ", body.name)  # Debug print
	if body.name == "player":  # Ensure the player node is referenced correctly
		label.visible = true

func _on_body_exited(body):
	print("body_exited: ", body.name)  # Debug print
	if body.name == "Player":  # Ensure the player node is referenced correctly
		label.visible = false
