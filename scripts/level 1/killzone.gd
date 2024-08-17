# KillZone.gd
# Handles the logic when the player enters a hazardous area (KillZone).

class_name KillZone
extends Area2D

var is_died: bool = false  # Tracks if the player has died
@onready var timer = $Timer  # Reference to the Timer node

# Triggered when another body (e.g., player) enters the KillZone
func _on_body_entered(body):
	if body is MyPlayer:  # Check if the body is the player
		body.damage(1)  # Inflict damage to the player
		if body.currentHealth <= 0:  # If player's health is depleted
			Engine.time_scale = 0.5  # Slow down time for effect
			body.get_node("CollisionShape2D").queue_free()  # Disable player's collision to prevent further input
			timer.start()  # Start the timer for delayed death

# Triggered when the timer times out, leading to player's death
func _on_timer_timeout():
	dead()

# Starts the timer (can be called from other scripts if needed)
func start_timer():
	timer.start()

# Handles the player's death, including transitioning to the Game Over screen
func dead():
	print("You died!")
	get_tree().change_scene_to_file("res://scenes/levels/global/gameover.tscn")

