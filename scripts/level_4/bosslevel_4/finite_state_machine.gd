extends Node2D

var current_state: Lvl4BossState
var previous_state: Lvl4BossState

func _ready():
	if get_child_count() > 0:
		current_state = get_child(0) as Lvl4BossState
		previous_state = current_state
		current_state.enter()
	else:
		print("No state nodes found.")

func change_state(state_name: String):
	var new_state = find_child(state_name) as Lvl4BossState
	if new_state == null:
		print("State not found: ", state_name)
		return

	if previous_state != null:
		previous_state.exit()

	previous_state = current_state
	current_state = new_state
	current_state.enter()
