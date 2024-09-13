extends Lvl4BossState

@onready var attack = $"../../Attack"


func enter():
	super.enter()
	animation_player.play("MeleeRight")
	attack.play()
	await animation_player.animation_finished
	
func transition():
	if owner.direction.length() > 50:
		get_parent().change_state("Follow")
