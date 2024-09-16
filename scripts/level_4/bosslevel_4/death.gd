extends Lvl4BossState

@onready var success = $"../../Success"
@onready var death = $"../../Death"


# Called when the node enters the scene tree for the first time.
func enter():
	super.enter()
	death.play()
	animation_player.play("Death")
	await animation_player.animation_finished
	await death.finished
	success.play()
	animation_player.play("boss_slained")
	await animation_player.animation_finished
	
