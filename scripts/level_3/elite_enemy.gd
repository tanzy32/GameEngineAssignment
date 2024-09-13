extends CharacterBody2D

const SPEED = 200.0  # Speed of movement during charge
const RETURN_SPEED = 75.0  # Slower speed for returning to the original position

@export var auto_move_direction: int = 1  # 1 for right, -1 for left

var is_player_nearby = false  # Track if player is in range
var is_charging = false  # Track if the enemy is currently charging
var is_returning = false  # Track if the enemy is returning to its idle position
var is_stopping = false  # Track if the enemy is in the stop phase
var original_position: Vector2  # Store the enemy's original position
var is_busy = false  # Track if the enemy is performing an action

# Get the gravity from the project settings
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# References to nodes
@onready var detection_area: Area2D = $DetectionArea
@onready var raycast_left: RayCast2D = $AnimatedSprite2D/RayCastLeft
@onready var raycast_right: RayCast2D = $AnimatedSprite2D/RayCastRight
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Timers for delayed actions
@onready var prepare_timer: Timer = Timer.new()
@onready var charge_timer: Timer = Timer.new()
@onready var stop_timer: Timer = Timer.new()
@onready var post_charge_timer: Timer = Timer.new()

func _ready():
	# Store the original position of the enemy
	original_position = global_position
	
	# Set up and connect timers
	prepare_timer.wait_time = 1.0
	prepare_timer.one_shot = true
	prepare_timer.timeout.connect(_on_prepare_timer_timeout)
	add_child(prepare_timer)
	
	charge_timer.wait_time = 1.0
	charge_timer.one_shot = true
	charge_timer.timeout.connect(_on_charge_timer_timeout)
	add_child(charge_timer)
	
	stop_timer.wait_time = 1.0
	stop_timer.one_shot = true
	stop_timer.timeout.connect(_on_stop_timer_timeout)
	add_child(stop_timer)
	
	post_charge_timer.wait_time = 1.0
	post_charge_timer.one_shot = true
	post_charge_timer.timeout.connect(_on_post_charge_timer_timeout)
	add_child(post_charge_timer)
	
	# Connect signals for entering and exiting the detection area
	detection_area.body_entered.connect(_on_player_entered)
	detection_area.body_exited.connect(_on_player_exited)

func _physics_process(delta):
	# Apply gravity if not on the floor
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle charging behavior
	if is_charging:
		velocity.x = auto_move_direction * SPEED
		flip_sprite(auto_move_direction)
		
		# Check for collisions using raycasts
		if raycast_left.is_colliding() or raycast_right.is_colliding():
			# Stop charging and enter stopping phase
			is_charging = false
			is_stopping = true
			velocity.x = 0
			print("collision detected, stopping")
	
	# Handle returning to the original position
	if is_returning:
		var direction_to_return = (original_position.x - global_position.x) / abs(original_position.x - global_position.x)
		velocity.x = direction_to_return * RETURN_SPEED
		flip_sprite(direction_to_return)
		
		# Stop moving if the enemy has returned to its original position
		if abs(global_position.x - original_position.x) < 1:
			is_returning = false
			is_busy = false
			velocity.x = 0
			is_player_nearby = false
	
	# Handle stopping phase
	if is_stopping:
		velocity.x = 0
		print("stopping")
	
	move_and_slide()

# Signal handler when player enters the detection area
func _on_player_entered(body):
	if body is MyPlayer and not is_player_nearby and not is_busy:
		is_player_nearby = true
		is_busy = true
		auto_move_direction = -1 if body.global_position.x < global_position.x else 1
		flip_sprite(auto_move_direction)
		prepare_timer.start()
		print("prepare")

# Timer handlers
func _on_prepare_timer_timeout():
	is_charging = true
	charge_timer.start()

func _on_charge_timer_timeout():
	is_charging = false
	post_charge_timer.start()

func _on_post_charge_timer_timeout():
	is_stopping = true
	stop_timer.start()

func _on_stop_timer_timeout():
	is_stopping = false
	is_returning = true

# Signal handler when player exits the detection area
func _on_player_exited(body):
	if body is MyPlayer:
		is_player_nearby = false

# Function to flip the sprite based on direction
func flip_sprite(direction: float):
	sprite.flip_h = direction < 0
