extends CharacterBody2D

@export var horizontal_jump_speed: float = 150.0  
@export var vertical_jump_speed: float = 220.0    
@export var gravity: float = 200.0                 
@export var idle_time: float = 0.5               
@onready var animated_sprite_2d = $AnimatedSprite2D
var jump_timer: float = 0.0
var is_jumping: bool = false

func _ready():
	var rng = RandomNumberGenerator.new()
	
	var random_x = rng.randi_range(-640,800)
	var random_y = rng.randi_range(-1600,-1300)
	position = Vector2(random_x,random_y)
	

func _process(delta):
	if is_on_floor():
		if is_jumping:
			is_jumping = false
			jump_timer = idle_time
			velocity.x = 0  
		else:
			jump_timer -= delta
			if jump_timer <= 0:
				_jump()

	if !is_on_floor():
		velocity.y += gravity * delta
	
	move_and_slide()

func _jump():
	var direction = -1 if randi() % 2 == 0 else 1
	velocity.x = direction * horizontal_jump_speed
	velocity.y = -vertical_jump_speed
	is_jumping = true
	
