extends CharacterBody2D

@export var horizontal_jump_speed: float = 150.0  
@export var vertical_jump_speed: float = 220.0    
@export var gravity: float = 200.0                 
@export var idle_time: float = 0.5      
  
@onready var spriteIdle = $idle
@onready var spriteJump = $jump
@onready var animations = $AnimationPlayer

var jump_timer: float = 0.0
var is_jumping: bool = false
var is_dead: bool = false

func _ready():
	var rng = RandomNumberGenerator.new()
	
	var random_x = rng.randi_range(-640, 800)
	var random_y = rng.randi_range(-1600, -1300)
	position = Vector2(random_x, random_y)

func _process(delta):
	if is_dead: return
	if is_on_floor():
		if is_jumping:
			# Slime has landed
			is_jumping = false
			jump_timer = idle_time
			spriteIdle.visible = true
			spriteJump.visible = false
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
	# Determine the direction of the jump
	var direction = -1 if randi() % 2 == 0 else 1
	velocity.x = direction * horizontal_jump_speed
	velocity.y = -vertical_jump_speed
	is_jumping = true
	# Play the jump animation
	spriteIdle.visible = false
	spriteJump.visible = true
	updateAnimation("jump")
	
func updateAnimation(animation: String):
	animations.play(animation)

func _on_hurt_box_area_entered(area):
	if area == $hitBox || area == $hurtBox: return
	$hitBox.set_deferred("monitorable",false)
	is_dead = true
	updateAnimation("death")
	await animations.animation_finished
	queue_free()
