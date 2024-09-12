extends Lvl4BossState

@onready var pivot = $"../../Pivot"
var can_transition: bool = false

func enter():
	super.enter()
	await play_animation("LongRangeSkill")
	can_transition = true

func play_animation(anim_name):
	animation_player.play(anim_name)
	await animation_player.animation_finished

#func set_target():
	## Calculate the direction to flip based on owner's direction
	#var flip = (owner.direction - pivot.position).x < 0 ? -1 : 1
	#pivot.scale.x = flip
	
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Follow")
