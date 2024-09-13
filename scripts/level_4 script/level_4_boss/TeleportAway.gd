extends Lvl4BossState

@onready var teleport_timer : Timer = Timer.new()  # Timer to control teleport timing
var teleport_distance = 30  # Fixed distance for teleportation from the player's position
var can_transition: bool = false

func enter():
	super.enter()
	print("Boss entered Teleport state")
	
	# Play the TeleportAway animation
	animation_player.play("TeleportAway")
	await animation_player.animation_finished
	# Teleport the boss after the animation finishes
	_teleport()
	can_transition = true

func exit():
	super.exit()

func _teleport():
	if owner.player == null:
		print("Error: Player node is null, cannot teleport.")
		return
	
	# Choose a random direction for teleportation based on player and platform position
	var direction = _choose_teleport_direction()
	
	# Calculate the new position by adding the direction scaled by the teleport distance
	var new_position = owner.player.position + (direction * teleport_distance)

	# Ensure the boss teleports within valid bounds (not less than x = 0 or y = 0)
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
	
	# Clamp position so that it never goes below x = 0 or y = 0, or outside the screen size
	pos.x = clamp(pos.x, 0, screen_size.x)
	pos.y = clamp(pos.y, 0, screen_size.y)
	
	return pos

func _choose_teleport_direction() -> Vector2:
	# Determine the player's position and check for platforms
	var player_position = owner.player.position
	var is_player_on_platform = _is_on_platform(player_position)
	var direction = Vector2()

	# Logic to teleport based on player's position
	if is_player_on_platform:
		# If the player is on a platform, teleport above them (upward)
		direction = Vector2(0, -1)  # Teleport upward
	else:
		# If the player is not on a platform, randomly choose between left, right, or above
		var random_choice = randi() % 3
		match random_choice:
			0:
				direction = Vector2(-1, 0)  # Teleport to the left
			1:
				direction = Vector2(1, 0)   # Teleport to the right
			2:
				direction = Vector2(0, -1)  # Teleport above the player

	return direction

func _is_on_platform(player_position: Vector2) -> bool:
	# Implement logic to determine if the player is on a platform
	# For example, using raycasting or checking if the player's position matches platform coordinates
	# This is just a placeholder for now:
	var platform_y_position = 300  # Example: platform Y position
	return player_position.y < platform_y_position  # Adjust based on actual platform logic
