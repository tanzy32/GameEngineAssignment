extends StateBoss

@onready var success = $"../../Success"
@onready var death = $"../../Death"

func enter():
	super.enter()
	death.play()
	boss_animation_player.play("death")
	await boss_animation_player.animation_finished
	await death.finished
	success.play()
	boss_animation_player.play("boss_slained")
	
