extends Lvl4BossState

@onready var teleport_timer : Timer = Timer.new()  # Timer to control teleport timing
var teleport_range = 10  # Max distance for teleportation from the player's position
var can_transition: bool = false

func enter():
	super.enter()
	print("Boss entered Teleport state")
	
	# Play the TeleportAway animation
	animation_player.play("TeleportAway")
	await animation_player.animation_finished
	# Set up the teleportation timer
	#teleport_timer.wait_time = animation_player.current_animation_length  # Sync with animation duration
	#teleport_timer.one_shot = true
	#teleport_timer.connect("timeout", Callable(self, "_teleport"))  
	#add_child(teleport_timer)
	#teleport_timer.start()
	_teleport()
	can_transition = true

func exit():
	super.exit()
	#teleport_timer.stop()  # Stop the timer when exiting the state

func _teleport():
	if owner.player == null:
		print("Error: Player node is null, cannot teleport.")
		return
	
	# Define a smaller radius for the teleport range
	var offset_radius = teleport_range * 0.5  # You can adjust this factor as needed
	
	# Generate a random offset within the smaller radius
	var random_angle = randf() * 2 * PI
	var random_distance = randf_range(0, offset_radius)
	var random_offset = Vector2(cos(random_angle) * random_distance, sin(random_angle) * random_distance)
	var new_position = owner.player.position + random_offset

	# Ensure the boss teleports within valid bounds
	new_position = clamp_position_within_bounds(new_position)

	# Update the boss position
	owner.position = new_position
	print("Boss teleported to: ", new_position)

	# Play the TeleportHere animation to show the boss reappearing
	animation_player.play("TeleportHere")
	await animation_player.animation_finished
	# Call the transition function to change state after animation is complete
	transition()


func transition():
	if can_transition:
			can_transition = false
			print("Transitioning to Follow state")
			get_parent().change_state("Follow")

func clamp_position_within_bounds(pos: Vector2) -> Vector2:
	# Ensure the boss doesn't teleport outside the screen (or game area)
	var screen_size = get_viewport_rect().size
	pos.x = clamp(pos.x, 0, screen_size.x)
	pos.y = clamp(pos.y, 0, screen_size.y)
	return pos
