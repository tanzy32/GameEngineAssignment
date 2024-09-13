extends Area2D  # Fireball is based on Area2D to detect collisions

@export var speed: float = 300.0  # Speed of the fireball
@export var damage: int = 10  # Amount of damage the fireball deals
var direction: Vector2 = Vector2.ZERO  # Direction in which the fireball moves

func _ready() -> void:
	# Connect to the "body_entered" signal to detect collisions with other bodies
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta: float) -> void:
	# Move the fireball in the specified direction
	if direction != Vector2.ZERO:
		position += direction * speed * delta

	# Check if the fireball goes out of bounds
	var viewport_rect = get_viewport().get_visible_rect()  # Get the visible rectangle of the viewport
	if not viewport_rect.has_point(global_position):  # Use global_position to check if it is within the viewport
		queue_free()  # Remove the fireball if it goes out of the screen

func _on_body_entered(body: Node) -> void:
	# Check if the fireball collides with a valid target (like a player or an enemy)
	if body.name == "Player":  # Replace with the correct type for your target
		body.take_damage(damage)  # Assuming the target has a 'take_damage' method
		queue_free()  # Remove the fireball after it hits the target
