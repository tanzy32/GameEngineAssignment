extends Lvl4BossState


# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("Idle")
	
func exit():
	super.exit()
	owner.set_physics_process(false)
	
func transition():
	var distance = owner.direction.length()
	
	if distance < 50: 
		get_parent().change_state("MeleeRight")
	elif distance > 70 and distance < 100 and owner.is_on_floor():
		# Randomly decide between LongRangeSkill or TeleportAway
		var random_choice = randi() % 2  # Get either 0 or 1
		match random_choice:
			0:
				get_parent().change_state("LongRangeSkill")
			1:
				return 
	elif distance > 200 and owner.is_on_floor():
		# Randomly decide with different probabilities
		var random_chance = randf()  # Get a random float between 0.0 and 1.0
		if random_chance < 0.1:  # 10% chance to teleport away
			get_parent().change_state("TeleportAway")
		else:  # 90% chance to perform Idle
			get_parent().change_state("Idle")




  
