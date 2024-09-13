extends CharacterBody2D

@export var horizontal_jump_speed: float = 150.0  
@export var vertical_jump_speed: float = 225.0    
@export var gravity: float = 200.0                 
@export var idle_time: float = 0.5      

@onready var slime_scene: PackedScene = load("res://scenes/levels/level_1/slime.tscn")
@onready var animations = $AnimationPlayer

var max_health: int
var current_health: int
var jump_timer: float = 0.0
var is_jumping: bool = false
var is_dead: bool = false

func _ready():
	pass
	
func _process(delta):
	if is_dead: return
	if is_on_floor():
		if is_jumping:
			# Slime has landed
			is_jumping = false
			jump_timer = idle_time
			updateAnimation("idle")
			velocity.x = 0  
		else:
			# Countdown to next jump
			jump_timer -= delta
			if jump_timer <= 0:
				_jump()
	else:
		# Slime is in the air, apply gravity
		velocity.y += gravity * delta
	# Handle movement and collisions
	move_and_slide()

func _jump():
	$Jump.play()
	# Determine the direction of the jump
	var direction = -1 if randi() % 2 == 0 else 1
	velocity.x = direction * horizontal_jump_speed
	velocity.y = -vertical_jump_speed
	is_jumping = true
	# Play the jump animation
	updateAnimation("jump")
	
func updateAnimation(animation: String):
	animations.play(animation)

func _on_hurt_box_area_entered(area):
	if area == $hitBox || area == $hurtBox: return
	
	if current_health <= 1:
		$hitBox.set_deferred("monitorable",false)
		is_dead = true
		updateAnimation("death")
		await animations.animation_finished
		
		if scale == Vector2(1,1):
			queue_free()
		else:
			split()
	current_health -= 1	
	print(current_health)

func split():
	# Create two smaller slimes by instantiating the slime_scene
	for i in range(2):
		var smaller_slime = slime_scene.instantiate()  # Instantiate a new slime from the slime_scene
		smaller_slime.scale = scale / 2  # Halve the size of the smaller slimes
		smaller_slime.position = position + Vector2(randi_range(-10, 10), randi_range(-10, 10))  # Slightly offset the position
		smaller_slime.current_health = max_health / 2  # Halve the health for the smaller slimes
		smaller_slime.max_health = max_health / 2
		queue_free()
		# Add the smaller slimes to the same parent node
		get_parent().add_child(smaller_slime)
