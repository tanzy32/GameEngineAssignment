extends Lvl4BossState


@onready var timer = $"../../TeleportTimer"


# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	owner.set_physics_process(true)
	animation_player.play("Idle")
	timer.wait_time = 5.0  # 30 seconds
	#timer.start()
	
func exit():
	super.exit()
	owner.set_physics_process(false)
	
func transition():
	var distance = owner.direction.length()
	
	# Print the current timer state
	print("Timer time left: ", timer.time_left)
	
	if distance < 70: 
		if owner.direction.x < 0:  # Player is to the lefta
			get_parent().change_state("MeleeRight")
	elif distance > 70 and distance < 100:
		var random_chance = randf()  # Get a random number between 0.0 and 1.0
		var chance_threshold = 0.1 
		if random_chance < chance_threshold:
			get_parent().change_state("LongRangeSkill")
	elif distance > 100: 
		# Check if the timer has completed
		if timer.time_left <= 0:
			get_parent().change_state("TeleportAway")
		# If timer has not completed, do nothing
		else:
			# Optionally, you can print or log here to confirm that the timer is still active
			print("Timer still running. Time left: ", timer.time_left)

		
			
		


  
