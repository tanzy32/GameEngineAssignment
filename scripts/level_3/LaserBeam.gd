extends StateBoss

@onready var laser = $"../../Laser"
@onready var pivot = $"../../Pivot"
var can_transition: bool = false
 
func enter():
	super.enter()
	await play_animation("laser_cast")
	await play_animation("laser")
	can_transition = true
	get_parent().change_state("Follow")
 
func play_animation(anim_name):
	boss_animation_player.play(anim_name)
	laser.play()
	await boss_animation_player.animation_finished
 
func set_target():
	pivot.rotation = (owner.direction - pivot.position).angle()
 

