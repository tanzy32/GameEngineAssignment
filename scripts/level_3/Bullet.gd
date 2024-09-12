extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var velocity: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var bullet_speed: float = 400

# Function to set the shooting direction from the golem's movement
func set_direction(dir: Vector2):
	direction = dir.normalized()

func _physics_process(delta):
	# Move the bullet only horizontally
	velocity = direction * bullet_speed
	# Set the Y component of velocity to zero to avoid vertical movement
	velocity.y = 0
	position += velocity * delta

func _on_body_entered(body):
	queue_free()  
