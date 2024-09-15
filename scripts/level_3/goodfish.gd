
extends CharacterBody2D
var rng:= RandomNumberGenerator.new()


@export var move_speed: float
@export var direction: Vector2 = Vector2.RIGHT

@onready var raycast_left: RayCast2D = $Sprite/RayCastLeft
@onready var raycast_right: RayCast2D = $Sprite/RayCastRight
@onready var fish: AnimatedSprite2D = $Sprite

func _ready():
	# Enable the RayCasts
	raycast_left.enabled = true
	raycast_right.enabled = true
	move_speed = rng.randi_range(110,220)
	
func _physics_process(delta):
	move(delta)
	
func move(delta):
	# Set velocity based on the direction and speed
	velocity = direction * move_speed
	
	# Check for collisions using RayCasts
	if direction == Vector2.LEFT and raycast_left.is_colliding():
		# If the fish is moving left and the RayCast hits something, switch direction
		direction = Vector2.RIGHT
	elif direction == Vector2.RIGHT and raycast_right.is_colliding():
		# If the fish is moving right and the RayCast hits something, switch direction
		direction = Vector2.LEFT

	# Set the sprite's flip based on the movement direction
	fish.flip_h = direction == Vector2.LEFT

	# Move the fish
	move_and_slide()
		
