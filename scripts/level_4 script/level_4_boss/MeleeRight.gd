extends Lvl4BossState

func enter():
	super.enter()
	animation_player.play("MeleeRight")

	
func transition():
	if owner.direction.length() > 50:
		get_parent().change_state("Follow")
