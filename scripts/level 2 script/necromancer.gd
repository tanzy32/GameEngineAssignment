extends CharacterBody2D


@onready var player = get_parent().find_child("Player")
@onready var sprite = $Sprite2D
@onready var progress_bar = %ProgressBar
 
var direction : Vector2
 
var health = 100:
	set(value):
		if value < health:
			find_child("FiniteStateMachine").change_state("Stagger")
 
		health = value
		progress_bar.value = value
 
		if value <= 0:
			progress_bar.visible = false
			find_child("FiniteStateMachine").change_state("Death")
			get_tree().change_scene_to_file("res://scenes/levels/level_3/level_3.tscn")
 
 
func _process(_delta):
	direction = player.position - position
 
	if direction.x < 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func take_damage():
	health -= 10


func _on_hurtbox_area_entered(area):
	take_damage()
