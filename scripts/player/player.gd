class_name MyPlayer
extends CharacterBody2D

signal healthChanged


# Enumeration for various character states
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
	ATTACK_1,
	ATTACK_2,
	ATTACK_3,
	ROW_1,
	DEATH,
}

# Define the states where the character is on the ground
const GROUND_STATES := [
	State.IDLE, State.RUNNING, State.LANDING,
	State.ATTACK_1,State.ATTACK_2,State.ATTACK_3,
	State.ROW_1,
]

# Define various constants for character movement
var RUN_SPEED := 160.0
const FLOOR_ACCELERATION := 160.0 / 0.2
const AIR_ACCELERATION := 160.0 / 0.1
var JUMP_VELOCITY := -500.0
const WALL_JUMP_VELOCITY := Vector2(500, -400)
const SLIDE_SPEED := 260.0

# Angelgrace skill variables
var normal_speed := RUN_SPEED
var normal_jump_velocity := JUMP_VELOCITY
var angelgrace_speed_multiplier := 2.0
var angelgrace_jump_multiplier := 2.0
var angelgrace_duration := 5.0  # 5 seconds active time
var angelgrace_cooldown := 30.0  # 30 seconds cooldown
var is_angelgrace_active := false
var angelgrace_timer := 0.0
var angelgrace_cooldown_timer := 0.0

@export var can_combo := false
@export var maxHealth: int = 4  # Maximum health for the player
@export var knockbackPower: int = 700
@export var inventory: Inventory = preload("res://scenes/levels/global/inventory/playerInventory.tres") 


# Get the default gravity value from project settings
var default_gravity:= ProjectSettings.get("physics/2d/default_gravity") as float
var is_first_tick := false
var jump_max = 1
var jump_count = 0
var is_combo_requested := false
var has_shot_arrow := false 
var isHurt: bool = false
var enemyCollisions = []

var is_using_slimy_coat: bool = false
var in_cooldown = false
var cooldown_timer = 30.0
var activation_timer = 5.0
var current_activation_time = 0.0
var current_cooldown_time = 0.0

var is_flying = false
var flight_duration = 5.0  # Fly for 3 seconds
var flight_cooldown = 30.0  # 5-second cooldown before flying again
var current_cooldown = 0.0  # Cooldown timer for flying

var is_game_over = false

# Cache references to various nodes
@onready var animation_player = $AnimationPlayer
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_request_timer: Timer = $JumpRequestTimer
@onready var state_machine: StateMachine = $StateMachine
@onready var graphics: Node2D = $Graphics
@onready var slide_timer: Timer = $SlideTimer
@onready var arrow = preload("res://scenes/player/arrow.tscn")
@onready var marker_2d: Marker2D = $Marker2D
@onready var arrow_timer: Timer = $ArrowTimer
@onready var hand_checker: RayCast2D = $Graphics/Sprite2D/HandChecker
@onready var foot_checker: RayCast2D = $Graphics/Sprite2D/FootChecker
@onready var hurtTimer: Timer = $hurtTimer
@onready var effects: AnimationPlayer = $Effects
@onready var death_timer = $PlayerUI/DeathTimer
@onready var currentHealth: int = 2
@onready var slime: Sprite2D = $Graphics/slime
@onready var reload_timer = $ReloadTimer
@onready var sprite_2d: Sprite2D = $Graphics/Sprite2D
@onready var game_over_ui = $GameOverUI
@onready var wings: Sprite2D = $Graphics/wings
@onready var buff: Sprite2D = $Graphics/buff


# Handle unhandled input events
func _unhandled_input(event: InputEvent) -> void:
	# Check if the game is over
	if is_game_over:
		# Ignore all input events if the game over UI is visible
		return
	
	if event.is_action_pressed("jump"):
		jump_request_timer.start()
	
	if event.is_action_released("jump"):
		jump_request_timer.stop()
		 # Reduce jump velocity for a shorter jump
		if velocity.y < JUMP_VELOCITY / 2: 
			velocity.y = JUMP_VELOCITY / 4
				
	if event.is_action_pressed("slide"):
		slide_timer.start()

	if event.is_action_pressed("attack") and can_combo:
		is_combo_requested = true
		
	if event.is_action_pressed("rowAttack"):
		arrow_timer.start()

	if event.is_action_pressed("slimyCoat"):
		use_slimy_coat()
	
	if event.is_action_pressed("fly") and current_cooldown <= 0.0:
		activate_wings()
	
	if event.is_action_pressed("angelgrace") and angelgrace_cooldown_timer <= 0:
		_activate_angelgrace()
	
	

# Update physics for each state
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
			if velocity.y < 0:
				velocity.y = 0
			
		State.WALL_JUMP:
			if state_machine.state_time < 0.1:
				stand(0.0 if is_first_tick else default_gravity,delta)
				#Flip character based on wall normal
				#Make the player always face away from the wall
				graphics.scale.x = -get_wall_normal().x
			else:
				move(default_gravity, delta)
			
		State.SLIDE:
			move(default_gravity, delta)	
		
		State.SLIDE_END:
			stand(default_gravity, delta)	

		State.ATTACK_1, State.ATTACK_2, State.ATTACK_3,State.ROW_1:
			stand(default_gravity, delta)
			
		State.ROW_1:
			move(default_gravity, delta)

	is_first_tick = false		
			
# Move character with specific gravity and delta time
func move(gravity: float, delta: float) -> void:
	var direction := Input.get_axis("left", "right")
	var acceleration :=  FLOOR_ACCELERATION if is_on_floor() else AIR_ACCELERATION
	velocity.x = move_toward(velocity.x, direction * RUN_SPEED, acceleration * delta)
	velocity.y += gravity * delta
	
	handleCollision()

	# Flip character direction based on movement
	if not is_zero_approx(direction):
		graphics.scale.x = -1 if direction > 0 else 1
	
	if !isHurt:
		for enemyArea in enemyCollisions:
			hurtByEnemy(enemyArea)
			
	if is_using_slimy_coat:
		current_activation_time += delta
		if current_activation_time >= activation_timer:
			deactivate_slimy_coat()
			
	if in_cooldown:
		current_cooldown_time -= delta
		if current_cooldown_time <= 0.0:
			end_cooldown()  # Reset the cooldown and other states
	
	if is_flying:
		velocity.y = Input.get_axis("move_up", "move_down") * RUN_SPEED
		velocity.x = Input.get_axis("left", "right") * RUN_SPEED
		flight_duration -= delta
		if flight_duration <= 0.0:
			deactivate_wings()
			
	# Reduce cooldown timer
	if current_cooldown > 0.0:
		current_cooldown -= delta
	
	if is_angelgrace_active:
		angelgrace_timer -= delta
		if angelgrace_timer <= 0:
			_deactivate_angelgrace()
	elif angelgrace_cooldown_timer > 0:
		angelgrace_cooldown_timer -= delta
				
	move_and_slide()
	
func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
	
# Stand still and apply gravity
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

func shoot_arrow() -> void:
	var arrow_instance = arrow.instantiate()
	if graphics.scale.x > 0:
		arrow_instance.global_position = global_position + marker_2d.position
		arrow_instance.scale.x = -1
		arrow_instance.velocity = Vector2(800, 0)
	else:
		arrow_instance.global_position = global_position + Vector2(-marker_2d.position.x, marker_2d.position.y)
		arrow_instance.scale.x = 1
		arrow_instance.velocity = Vector2(-800, 0)
	get_tree().current_scene.add_child(arrow_instance)

func increase_health(amount: int) -> void:
	currentHealth += amount
	currentHealth = min(maxHealth, currentHealth)
	healthChanged.emit(currentHealth)
	
func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()

func _ready():
	effects.play("RESET")
	if game_over_ui.visible:
		set_process_unhandled_input(false)
	# Initialize player settings
	inventory.use_item.connect(use_item)
	Global.playerBody = self  # Register the player in a global variable (if needed)
	
	slime.visible = false
	slime.modulate = Color(1, 1, 1, 0.5)
	
	wings.visible = false
	wings.modulate = Color(1, 1, 1, 0.5)
	
#	buff.visible = false
	
	# Initialize the normal values
	RUN_SPEED = normal_speed
	JUMP_VELOCITY = normal_jump_velocity
	
	# Reset health
	currentHealth = maxHealth
	
	
# Determine the next state based on the current state and conditio	
func get_next_state(state: State) -> State:
	var direction := Input.get_axis("left", "right")
	var is_still := is_zero_approx(direction) and is_zero_approx(velocity.x)
	
	var can_jump := is_on_floor() or coyote_timer.time_left > 0 or jump_count < jump_max
	var should_jump := can_jump and jump_request_timer.time_left > 0
	
	#if state in GROUND_STATES and not is_on_floor() and is_using_wings:
		#return State.FALL

	if is_on_floor():
		jump_count = 0
		
	if should_jump:
		jump_count += 1 
		return State.JUMP
	
	if state != State.DEATH and currentHealth <= 0:
		currentHealth = 0
		return State.DEATH
	
	match state:
		State.IDLE:
			if not is_still:
				return State.RUNNING
			if should_slide():
				return State.SLIDE
			if Input.is_action_just_pressed("attack"):
				return State.ATTACK_1
			if Input.is_action_just_pressed("rowAttack"):
				return State.ROW_1
			if Input.is_action_just_pressed("jump"):
				return State.JUMP
				
		State.RUNNING:
			if Input.is_action_just_pressed("attack"):
				return State.ATTACK_1
			if Input.is_action_just_pressed("rowAttack"):
				return State.ROW_1
			if is_still:
				return State.IDLE
			if should_slide():
				return State.SLIDE
			
		State.JUMP:
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
				return State.FALL
				
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
		
		State.ATTACK_1:
			if not animation_player.is_playing():
				return State.ATTACK_2 if is_combo_requested else State.IDLE
		
		State.ATTACK_2:
			if not animation_player.is_playing():
				return State.ATTACK_3 if is_combo_requested else State.IDLE
		
		State.ATTACK_3:
			if not animation_player.is_playing():
				return State.IDLE
				
		State.ROW_1:
			if not animation_player.is_playing():
				return State.IDLE
			if arrow_timer.time_left <= 0.2 and not has_shot_arrow:
				arrow_timer.stop()
				has_shot_arrow = true
				shoot_arrow()
				
		State.DEATH:
			if currentHealth <= 0 and death_timer.time_left <= 0.1:
				print("currentHealth: ", currentHealth)
				currentHealth = maxHealth
				print("currentHealth: ", currentHealth)
				print("death_timer: ", death_timer.time_left)
				death_timer.stop()
				return State.IDLE
				
	return state


# Handle state transitions
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
			has_shot_arrow = false
		
		State.RUNNING:
			animation_player.play("running")
		
		State.JUMP:
			animation_player.play("jump")
			velocity.y = JUMP_VELOCITY
			coyote_timer.stop()
			jump_request_timer.stop()
			$Jump.play()

			
		State.FALL:
			animation_player.play("fall")
			$Fall.play()
			if from in GROUND_STATES:
				coyote_timer.start()
			
		State.LANDING:
			jump_count = 0
			animation_player.play("landing")
			$Land.play()

		State.WALL_SLIDING:
			animation_player.play("wall_sliding")
			$WallSlide.play()
		
		State.WALL_JUMP:
			animation_player.play("jump")
			$Jump2.play()
			velocity = WALL_JUMP_VELOCITY
			velocity.x *= get_wall_normal().x
			jump_request_timer.stop()
			
		State.SLIDE:
			animation_player.play("slide")
			$Slide.play()

		State.SLIDE_END:
			animation_player.play("slide_end")
			slide_timer.stop()

		State.ATTACK_1:
			animation_player.play("attack01")
			$Attack1.play()
			is_combo_requested = false
		
		State.ATTACK_2:
			animation_player.play("attack02")
			$Attack2.play()
			is_combo_requested = false
		
		State.ATTACK_3:
			animation_player.play("attack03")
			$Attack3.play()
			is_combo_requested = false
			
		State.ROW_1:
			animation_player.play("row01")
			$Arrow.play()
			
		State.DEATH:
			print("Entering DEATH state")
			death_timer.start()
			animation_player.play("death")
			$Death.play()

	if to == State.WALL_JUMP:
		Engine.time_scale = 1.0
	if from == State.WALL_JUMP:
		Engine.time_scale = 1.0
	
	is_first_tick = true


func hurtByEnemy(area):
	if not is_using_slimy_coat:
		currentHealth -= 1
		if currentHealth < 1:
			game_over()  # Call the game over function
			return
			
		healthChanged.emit(currentHealth)

		isHurt = true
		$PlayerDamage.play()
		# Check if the parent of the area is a TileMap to avoid accessing velocity
		var parent = area.get_parent()
		if parent is TileMap:
			# If it's a TileMap, skip knockback as there's no velocity
			print("Hit by TileMap, applying fixed knockback.")
			var fixed_velocity = Vector2(100, 0)  # Example fixed velocity
			knockback(fixed_velocity)
		else:
			# Check if the parent has a velocity property
			if parent.has_method("get_velocity"):
				knockback(parent.get_velocity())
			else:
				# Fallback to fixed velocity if no velocity property is found
				print("Parent has no velocity, applying fixed knockback.")
				var fallback_velocity = Vector2(100, 0)
				knockback(fallback_velocity)
		
		effects.play("hurtBlink")
		hurtTimer.start()

		await hurtTimer.timeout

		effects.play("RESET")
		isHurt = false

func game_over():
	get_tree().paused = true
	is_game_over = true
	$GameOverUI.visible = true
	$BubbleUI.visible = false
	$PlayerUI.visible = false
	# Disable processing of physics and input
	set_process(false)
	set_physics_process(false)

func use_item(item: InventoryItem) -> void:
	print("drink")
	$UseItem.play()
	if item == null:
		print("Item is null")
		return
	if self == null:
		print("Global.playerBody is null")
		return
	print("Using item on:", self)
	item.use(self)


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if "hitBox" in area.name:
		enemyCollisions.append(area)


func _on_hurtbox_area_exited(area: Area2D) -> void:
	enemyCollisions.erase(area)


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.has_method("is_enemy") and area.is_enemy():
		queue_free()
		
func use_slimy_coat():
	if not is_using_slimy_coat and not in_cooldown:
		$SlimyCoat.play()
		is_using_slimy_coat = true
		current_activation_time = 0.0
		in_cooldown = true
		current_cooldown_time = cooldown_timer
		
		slime.visible = true
		
		print("Slimy coat activated for ", activation_timer, " seconds.")
	elif in_cooldown:
		print("Slimy coat is cooling down. Time remaining: ", current_cooldown_time, " seconds.")
	else:
		print("Slimy coat is already active.")

func deactivate_slimy_coat():
	is_using_slimy_coat = false
	in_cooldown = true
	current_activation_time = 0.0
	current_cooldown_time = cooldown_timer
	
	slime.visible = false
	
	print("Slimy coat deactivated. Cooldown started.")

func end_cooldown():
	in_cooldown = false
	current_cooldown_time = 0.0
	print("Cooldown finished. Slimy coat is ready to use again.")

func activate_wings():
	if is_flying == false:
		print("Wings activated!")
		is_flying = true
		flight_duration = 5.0  # Reset flight duration
		wings.visible = true
		velocity.y = 0  # Disable gravity while flying
	
	
func deactivate_wings():
	print("Wings deactivated!")
	is_flying = false
	wings.visible = false
	current_cooldown = flight_cooldown  # Start cooldown
	animation_player.play("fall")  # Return to idle state after flying

func _activate_angelgrace():
	if not is_angelgrace_active:
		RUN_SPEED = normal_speed * angelgrace_speed_multiplier
		JUMP_VELOCITY = normal_jump_velocity * angelgrace_jump_multiplier
		is_angelgrace_active = true
		buff.visible = true
		angelgrace_timer = angelgrace_duration
		angelgrace_cooldown_timer = angelgrace_cooldown

func _deactivate_angelgrace():
	RUN_SPEED = normal_speed
	JUMP_VELOCITY = normal_jump_velocity
	is_angelgrace_active = false
	buff.visible = false
