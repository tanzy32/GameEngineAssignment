extends Node2D

var current_state: Lvl4BossState
var previous_state: Lvl4BossState

func _ready():
	current_state = get_child(0) as Lvl4BossState
	previous_state = current_state
	current_state.enter()


func change_state(state):
	current_state = find_child(state) as Lvl4BossState
	current_state.enter()
	
	previous_state.exit()
	previous_state = current_state
