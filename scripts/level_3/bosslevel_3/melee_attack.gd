extends StateBoss

@onready var attack = $"../../Attack"


func enter():
	super.enter()
	boss_animation_player.play("melee_attack")
	attack.play()
	await boss_animation_player.animation_finished
 
func transition():
	if owner.direction.length() > 50:
		get_parent().change_state("Follow")
