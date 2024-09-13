extends CharacterBody2D

#@onready var player = get_parent().find_child("Player")
@onready var sprite = $Sprite2D
@onready var player = $"../Player"
@onready var pivot = $Pivot
@onready var progress_bar = $UI/ProgressBar
@onready var hitbox: Area2D = $Sprite2D/hitBox
@onready var collision_shape_2d: CollisionShape2D = $Sprite2D/hitBox/CollisionShape2D




var direction : Vector2
var DEF = 0
var health = 500.0
var gravity = 500.0 
var max_fall_speed = 200.0 



func _ready():
	set_physics_process(false)
	
func _process(_delta):
	direction = player.position - position
	
	if direction.x < 0:
		sprite.flip_h = true
		pivot.scale.x = -1
	else:
		sprite.flip_h = false
		pivot.scale.x = 1

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_fall_speed)
	velocity.x = direction.normalized().x * 80
	move_and_slide()

	
func take_damage():
	health -= 10 - DEF
	update_health()
	
func update_health():
	progress_bar.value = health
	if health <= 0:
		progress_bar.visible = false
		find_child("FiniteStateMachine").change_state("Death")
		get_tree().change_scene_to_file("res://scenes/menus/ending_scene.tscn")
	elif health <= progress_bar.max_value / 2 and DEF == 0:
		DEF = 5
	




# Detect when the hurtbox is entered and apply damage
func _on_hurtbox_area_entered(area: Area2D) -> void:
	take_damage()





