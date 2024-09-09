extends StateBoss


func enter():
	super.enter()
	boss_animation_player.play("death")
	await boss_animation_player.animation_finished
	boss_animation_player.play("boss_slained")
