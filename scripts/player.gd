extends CharacterBody2D

enum State{
	IDLE,
	RUNNING,
	JUMP,
	FALL,
	LANDING,
	WALL_SLIDING,
	WALL_JUMP,
	SLIDE,
	SLIDE_END,
}

const GROUND_STATES := [
	State.IDLE, State.RUNNING, State.LANDING,
]
const RUN_SPEED := 160.0
const FLOOR_ACCELERATION := RUN_SPEED / 0.2
const AIR_ACCELERATION := RUN_SPEED / 0.1
const JUMP_VELOCITY := -500.0
const WALL_JUMP_VELOCITY := Vector2(500, -400)
const SLIDE_SPEED := 260.0

var default_gravity:= ProjectSettings.get("physics/2d/default_gravity") as float
var is_first_tick := false
var jump_max = 1
var jump_count = 0


@onready var animation_player = $AnimationPlayer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_request_timer: Timer = $JumpRequestTimer
@onready var state_machine: StateMachine = $StateMachine
@onready var graphics: Node2D = $Graphics
@onready var foot_checker: RayCast2D = $Graphics/Sprite2D/FootChecker
@onready var hand_checker: RayCast2D = $Graphics/Sprite2D/HandChecker
@onready var slide_timer: Timer = $SlideTimer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jump_request_timer.start()
	
	if event.is_action_released("jump"):
		jump_request_timer.stop()
		if velocity.y < JUMP_VELOCITY / 2:
			velocity.y = JUMP_VELOCITY / 4
				
	if event.is_action_pressed("slide"):
		slide_timer.start()



func tick_physics(state: State, delta: float) -> void:		
	match state:
		State.IDLE:
			move(default_gravity,delta)
			
		State.RUNNING:
			move(default_gravity, delta)
			
		State.JUMP:
			move(0.0 if is_first_tick else default_gravity, delta)
			
		State.FALL:
			move(default_gravity, delta)
			
		State.LANDING:
			stand(default_gravity, delta)
			
		State.WALL_SLIDING:
			move(default_gravity / 8, delta)
			
		State.WALL_JUMP:
			if state_machine.state_time < 0.1:
				stand(0.0 if is_first_tick else default_gravity,delta)
				graphics.scale.x = -get_wall_normal().x
			else:
				move(default_gravity, delta)
			
		State.SLIDE:
			move(default_gravity, delta)	
		
		State.SLIDE_END:
			stand(default_gravity, delta)	
			
	is_first_tick = false		
			
func move(gravity: float, delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	var acceleration :=  FLOOR_ACCELERATION if is_on_floor() else AIR_ACCELERATION
	velocity.x = move_toward(velocity.x, direction * RUN_SPEED, acceleration * delta)
	velocity.y += gravity * delta

	if not is_zero_approx(direction):
		graphics.scale.x = -1 if direction > 0 else 1
	
	move_and_slide()
	
	
func stand(gravity: float, delta: float) -> void:
	var acceleration := FLOOR_ACCELERATION if is_on_floor() else AIR_ACCELERATION
	velocity.x = move_toward(velocity.x, 0.0, acceleration * delta)
	velocity.y += gravity * delta
	
	move_and_slide()

func slide(delta: float) -> void:
	velocity.x = graphics.scale.x * SLIDE_SPEED
	velocity.y += default_gravity * delta
	
	move_and_slide()

func should_slide() -> bool:
	if not Input.is_action_just_pressed("slide") or is_on_wall():
		return false
	return Input.is_action_just_pressed("slide") and not foot_checker.is_colliding()
	
func can_wall_slide() -> bool:
	return is_on_wall() and hand_checker.is_colliding() and foot_checker.is_colliding()
	
	
func get_next_state(state: State) -> State:
	var direction := Input.get_axis("move_left", "move_right")
	var is_still := is_zero_approx(direction) and is_zero_approx(velocity.x)
	
	var can_jump := is_on_floor() or coyote_timer.time_left > 0 or jump_count < jump_max
	var should_jump := can_jump and jump_request_timer.time_left > 0

	if is_on_floor():
		jump_count = 0
		
	if should_jump:
		jump_count += 1 
		return State.JUMP
			
	match state:
		State.IDLE:
			if not is_on_floor():
				return State.FALL
			if not is_still:
				return State.RUNNING
			if should_slide():
				return State.SLIDE
				
		State.RUNNING:
			if not is_on_floor():
				return State.FALL
			if is_still:
				return State.IDLE
			if should_slide():
				return State.SLIDE
			
		State.JUMP:
			print("jump count remaining:", jump_count)
			if velocity.y >= 0 or jump_count < jump_max:
				return State.FALL
			if is_on_wall():
				return State.WALL_SLIDING
			
		State.FALL:
			if is_on_floor():
				return State.LANDING if is_still else State.RUNNING
			if can_wall_slide():
				return State.WALL_SLIDING

		State.LANDING:
			if not is_still:
				return State.RUNNING
			if not animation_player.is_playing():
				return State.IDLE
		
		State.WALL_SLIDING:
			if jump_request_timer.time_left > 0:
				return State.WALL_JUMP
			if is_on_floor():
				return State.IDLE
			if not is_on_wall():
				return  State.FALL
				
		State.WALL_JUMP:
			if can_wall_slide() and not is_first_tick:
				return State.WALL_SLIDING
			if velocity.y >= 0:
				return State.FALL
			
		State.SLIDE:
			if not is_on_floor():
				return State.FALL
			if is_on_wall():
				return State.SLIDE_END
			if slide_timer.time_left > 0:
				print("Slide time remaining:", slide_timer.time_left)
				return State.SLIDE
			else:
				print("Slide timer expired")
				return State.SLIDE_END
				
		State.SLIDE_END:
			return State.IDLE
		
	return state


func transition_state(from: State, to: State) -> void:
	print("[%s] %s => %s" % [
		Engine.get_physics_frames(),
		State.keys()[from] if from != -1 else "<START>",
		State.keys()[to],
	])
	
	if from not in GROUND_STATES and to in GROUND_STATES:
		coyote_timer.stop()
	
	match to:
		State.IDLE:
			animation_player.play("idle")
		
		State.RUNNING:
			animation_player.play("running")
		
		State.JUMP:
			animation_player.play("jump")
			velocity.y = JUMP_VELOCITY
			coyote_timer.stop()
			jump_request_timer.stop()
			
		
		State.FALL:
			animation_player.play("fall")
			if from in GROUND_STATES:
				coyote_timer.start()
			
		State.LANDING:
			jump_count = 0
			animation_player.play("landing")

		State.WALL_SLIDING:
			animation_player.play("wall_sliding")
		
		State.WALL_JUMP:
			animation_player.play("jump")
			velocity = WALL_JUMP_VELOCITY
			velocity.x *= get_wall_normal().x
			jump_request_timer.stop()
			
		State.SLIDE:
			animation_player.play("slide")

		State.SLIDE_END:
			animation_player.play("slide_end")
			slide_timer.stop()
	
	if to == State.WALL_JUMP:
		Engine.time_scale = 0.3
	if from == State.WALL_JUMP:
		Engine.time_scale = 1.0
	
	is_first_tick = true
			
