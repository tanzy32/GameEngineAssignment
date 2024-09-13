extends Node2D
 
var current_state: lvl2_State
var previous_state: lvl2_State
 
func _ready():
	current_state = get_child(0) as lvl2_State
	previous_state = current_state
	current_state.enter()
 
func change_state(state):
	if state == previous_state.name:
		return
 
	current_state = find_child(state) as lvl2_State
	current_state.enter()
 
 
	previous_state.exit()
	previous_state = current_state
 
