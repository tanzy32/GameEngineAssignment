extends CharacterBody2D

@onready var player: MyPlayer = $"../Player"
@onready var golem: Sprite2D = $Golem
@onready var progress_bar: ProgressBar = $UI/ProgressBar
@onready var hit_box: Area2D = $Golem/hitBox
@onready var collision_shape_2d: CollisionShape2D = $Golem/hitBox/CollisionShape2D

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
		golem.flip_h = true
	else:
		golem.flip_h = false
 

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	velocity.y = min(velocity.y, max_fall_speed)
	velocity.x = direction.normalized().x * 80
	move_and_slide()
 

func take_damage():
	health -= 10 - DEF
	update_health()

# Function to update health and the progress bar
func update_health():
	progress_bar.value = health
	if health <= 0:
		progress_bar.visible = false
		find_child("FiniteStateMachine").change_state("Death")
	elif health <= progress_bar.max_value / 2 and DEF == 0:
		DEF = 5
		find_child("FiniteStateMachine").change_state("ArmorBuff")

# Detect when the hurtbox is entered and apply damage
func _on_hurtbox_area_entered(area: Area2D) -> void:
	take_damage()
