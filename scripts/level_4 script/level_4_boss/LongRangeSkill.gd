extends Lvl4BossState

@onready var pivot = $"../../Pivot"
var can_transition: bool = false

func enter():
	super.enter()
	await play_animation("LongRangeSkill")
	can_transition = true


func play_animation(anim_name):
	animation_player.play(anim_name)
	$"../../Skill".play()
	await animation_player.animation_finished

	
func transition():
	if can_transition:
		can_transition = false
		get_parent().change_state("Follow")
