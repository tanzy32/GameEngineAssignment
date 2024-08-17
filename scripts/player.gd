extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

const wall_jump_pushback = 200
const wall_slide_gravity = 200
var is_wall_sliding = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	jump()
	wall_slide(delta)
	move_and_slide()

func jump():
	if Input.is_action_just_pressed("jump"):
		if is_on_floor:
			velocity.y = JUMP_VELOCITY
		if is_on_wall() and Input.is_action_pressed("right"):
			velocity.y = JUMP_VELOCITY
			velocity.x = -wall_jump_pushback

		if is_on_wall() and Input.is_action_pressed("left"):
			velocity.y = JUMP_VELOCITY
			velocity.x = wall_jump_pushback
			
func wall_slide(delta):
	if is_on_wall() and !is_on_floor():
		if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
			is_wall_sliding = true
		else:
			is_wall_sliding = false
	else:
		is_wall_sliding = false

	if is_wall_sliding:
		velocity.y += (wall_slide_gravity * delta)
		velocity.y = min(velocity.y, wall_slide_gravity)
