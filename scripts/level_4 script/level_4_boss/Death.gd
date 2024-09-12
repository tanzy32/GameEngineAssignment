extends Lvl4BossState


# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	animation_player.play("Death")
	await animation_player.animation_finished
	animation_player.play("boss_slained")
