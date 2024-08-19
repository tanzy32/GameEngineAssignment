class_name MyPlayer
extends CharacterBody2D

signal healthChanged

# Player settings
@export var speed: int = 300  # Player movement speed
@export var gravity: int = 30  # Gravity affecting the player
@export var jump_force: int = 300  # Force applied when the player jumps
@export var inventory: Inventory

@export var maxHealth: int = 4 # Maximum health for the player
@onready var currentHealth: int = maxHealth

@export var knockbackPower: int = 700 
var can_control: bool = true  # Indicates if the player can be controlled

@onready var effects = $Effects
@onready var hurtTimer = $hurtTimer
@onready var animations = $AnimationPlayer
@onready var weapon = $weapon

var isHurt: bool = false
var enemyCollisions = []
var lastAnimDirection: String = "Right"
var isAttacking: bool = false


func _ready():
	weapon.disable()
	effects.play("RESET")
	# Initialize player settings
	inventory.use_item.connect(use_item)
	Global.playerBody = self  # Register the player in a global variable (if needed)

func handleInput():
	if Input.is_action_just_pressed("attack"):
		attack()

func attack():
	weapon.enable()
	isAttacking = true
	animations.play("attack" + lastAnimDirection)
	await animations.animation_finished
	weapon.disable()
	isAttacking = false
	
		
func _physics_process(_delta):
	handleInput()
	handleCollision()
	
	if not can_control:
		return  # Exit if the player cannot be controlled

	# Apply gravity when the player is not on the floor
	if not is_on_floor():
		velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000  # Cap the falling speed

	# Handle jump action
	if Input.is_action_just_pressed("jump"):
		velocity.y = -jump_force
	
	# Handle horizontal movement
	var horizontal_direction = Input.get_axis("left", "right")
	velocity.x = speed * horizontal_direction
	if horizontal_direction < 0:
		lastAnimDirection = "Left"
	if horizontal_direction > 0:
		lastAnimDirection = "Right"
		
	move_and_slide()  # Execute the movement
	if !isHurt:
		for enemyArea in enemyCollisions:
			hurtByEnemy(enemyArea)
			
func handleCollision():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

func hurtByEnemy(area):
	currentHealth -= 1
	if currentHealth < 1:
		currentHealth = maxHealth
	
	healthChanged.emit(currentHealth)
	
	isHurt = true
	knockback(area.get_parent().velocity)
	effects.play("hurtBlink")
	hurtTimer.start()
	
	await hurtTimer.timeout
	
	effects.play("RESET")
	isHurt = false
	
func _on_hurt_box_area_entered(area):
	if area.name == "hitBox":
		enemyCollisions.append(area)
		
	if area.has_method("collect"):
		area.collect(inventory)

func knockback(enemyVelocity: Vector2):
	var knockbackDirection = (enemyVelocity - velocity).normalized() * knockbackPower
	velocity = knockbackDirection
	move_and_slide()

func increase_health(amount: int) -> void:
	currentHealth += amount
	currentHealth = min(maxHealth, currentHealth)
	healthChanged.emit(currentHealth)
	
func use_item(item: InventoryItem) -> void:
	item.use(self)

func _on_hurt_box_area_exited(area):
	enemyCollisions.erase(area)

	
