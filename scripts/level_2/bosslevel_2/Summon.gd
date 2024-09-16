extends lvl2_State


@export var skeleton_node: PackedScene
var can_transition : bool
var max_skeletons = 3
var spawned_skeletons = 0
 
 
func enter():
	super.enter()
	can_transition = false
 
	animation_player.play("summon")
	await animation_player.animation_finished 
 
	can_transition = true
 
func spawn():
	if spawned_skeletons < max_skeletons:
		var skeleton = skeleton_node.instantiate()
 
		skeleton.position = global_position + Vector2(40,40)
 
		get_tree().current_scene.call_deferred("add_child",skeleton)
		skeleton.connect("death", Callable(self, "_on_skeleton_death"))
		spawned_skeletons +=1
 
func transition():
	if can_transition and spawned_skeletons < max_skeletons:
		spawn()
		get_parent().change_state("Attack")

func _on_skeleton_death():
	if spawned_skeletons >0:
		spawned_skeletons -=1
