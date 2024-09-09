extends StateBoss

var can_transition : bool = false
 
func enter():
	super.enter()
	boss_animation_player.play("armor_buff")
	await boss_animation_player.animation_finished
	can_transition = true
 
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Follow")
