extends CharacterBody2D


var speed = -20.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var facing_right = false
var max_hp = 100
var current_health = 3
var is_dead: bool = false

func _ready():
	$AnimatedSprite2D.play("run")
	


func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if !$RayCast2D_floor.is_colliding() && is_on_floor():
		flip()
	
	
	velocity.x = speed

	move_and_slide()
	
func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1
		
func _on_hurt_box_area_entered(area):
	if area == $HitBox || area == $HurtBox: return
	
	if current_health <= 1:
		$HitBox.set_deferred("monitorable",false)
		is_dead = true
		queue_free()
	current_health -= 1	
	print(current_health)

func take_damage(damage):
	current_health -=damage
	$ProgressBar.value = current_health
	if current_health <=0:
		die()
func die():
	queue_free()  # Or any other death behavior

