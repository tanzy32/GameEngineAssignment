extends StateBoss

var can_transition: bool = false
const DASH_DISTANCE = 100

func enter():
	super.enter()
	boss_animation_player.play("glowing")
	await dash()
	can_transition = true
	
	
func dash():
	#var forward_direction = player.direction.normalized() * DASH_DISTANCE
	
	var tween = get_tree().create_tween()
	tween.tween_property(owner, owner.position, player.position, 0.8)
	await tween.finished

 
func transition():
	if can_transition:
		can_transition = false
 
		get_parent().change_state("Follow")
