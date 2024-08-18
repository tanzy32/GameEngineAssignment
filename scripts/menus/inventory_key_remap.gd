extends Button



@onready var remapping=false
@onready var remap_events=[]

@export var action: String = "toggle_inventory"

func _ready():
	update_key_text()
	
func update_key_text():
	text = "%s" % InputMap.action_get_events(action)[0].as_text().trim_suffix(" (Physical)")

func _on_pressed():
	if remapping:
		# Finalize remapping
		remapping = false
		update_key_text()
	else:
		# Start remapping
		remap_events = InputMap.action_get_events(action)
		InputMap.action_erase_events(action)
		remapping = true
		text = "Press a new key..."

func _input(event):
	if remapping:
		if event is InputEventKey:
			 # Add the new key event to the action
			InputMap.action_add_event(action, event)
			# End remapping
			remapping = false
			update_key_text()
