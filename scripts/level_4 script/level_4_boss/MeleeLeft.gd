extends Lvl4BossState

func enter():
	super.enter()
	animation_player.play("MeleeLeft")
	
func transition():
	if owner.direction.length() > 30:
		get_parent().change_state("Follow")
