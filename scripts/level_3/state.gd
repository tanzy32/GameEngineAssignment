extends Node2D
class_name StateBoss

@onready var boss_animation_player: AnimationPlayer = $"../../BossAnimationPlayer"
@onready var player: MyPlayer = $Player
@onready var debug: Label = $"../../Debug"

func _ready():
	set_physics_process(false)
 
func enter():
	set_physics_process(true)
 
func exit():
	set_physics_process(false)
 
func transition():
	pass
 
func _physics_process(_delta):
	transition()
	debug.text = name
 
