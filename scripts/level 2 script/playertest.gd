class_name Player
extends CharacterBody2D

@export var speed = 300
@export var gravity = 30
@export var jump_force = 300

var can_control: bool = true

func _ready():
	Global.playerBody = self

func _physics_process(_delta):
	if not can_control: return
	
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000
	
	if Input.is_action_just_pressed("jump"):
		velocity.y = -jump_force
		
	var horizontal_direction = Input.get_axis("left","right")
	velocity.x = speed * horizontal_direction
	move_and_slide()
	

