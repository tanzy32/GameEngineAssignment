extends Node2D
 
var current_state: StateBoss
var previous_state: StateBoss
 
func _ready():
	current_state = get_child(0) as StateBoss
	previous_state = current_state
	current_state.enter()
 
func change_state(state):
	current_state = find_child(state) as StateBoss
	current_state.enter()
 
	previous_state.exit()
	previous_state = current_state
