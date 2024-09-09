extends StateBoss
 
func enter():
	super.enter()
	owner.set_physics_process(true)
	boss_animation_player.play("idle")


func exit():
	super.exit()
	owner.set_physics_process(false)


func transition():
	var distance = owner.direction.length()
 
	if distance < 50:
		get_parent().change_state("MeleeAttack")
	elif distance > 150 and distance < 250:
		var chance = randi() % 2
		match chance:
			0:
				get_parent().change_state("HomingMissile")
			1:
				get_parent().change_state("LaserBeam")
