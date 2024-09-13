extends CharacterBody2D

const speed = 30
var dir: Vector2

var is_bat_chase: bool
var player: CharacterBody2D
var max_hp = 1000
var current_health = 3
var is_dead: bool = false

func _ready():
	is_bat_chase = true
	

func _process(delta):
	move(delta)
	handle_animation()

func move(delta):
	if is_bat_chase:
		player = Global.playerBody
		velocity = position.direction_to(player.position) * speed
		dir.x = abs(velocity.x)/ velocity.x
	elif !is_bat_chase:
		velocity += dir * speed * delta 
	move_and_slide()

func _on_timer_timeout():
	$Timer.wait_time = choose([0.5, 0.8])
	if !is_bat_chase:
		dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
	
	
func handle_animation():
	var animated_sprite = $AnimatedSprite2D
	animated_sprite.play("fly")
	if dir.x == -1:
		animated_sprite.flip_h = true
	elif dir.x == 1:
		animated_sprite.flip_h = false

func choose (array):
	array.shuffle()
	return array.front()
	
func _on_hurt_box_area_entered(area):
	if area == $hitBox || area == $hurtBox: return
	
	if current_health <= 1:
		$hitBox.set_deferred("monitorable",false)
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
	queue_free()
