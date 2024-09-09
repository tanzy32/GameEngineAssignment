extends CharacterBody2D

var arrow_velocity: Vector2 = Vector2.ZERO
var speed: float = 180.0

func _ready() -> void:
	# Start moving the arrow as soon as it is instantiated
	velocity = Vector2(speed, 0)
	print("Arrow added: ", self)


func _physics_process(delta: float) -> void:
	if scale.x > 0:
		global_position += velocity * delta
	else:
		global_position += velocity * -delta
	
	
func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.has_method("is_enemy") and area.is_enemy():
		queue_free()
	area.take.damege()

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
