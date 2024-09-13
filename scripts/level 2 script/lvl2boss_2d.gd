extends CharacterBody2D

@export var attack_cooldown = 3.0
@export var spawn_cooldown = 20.0
@export var enemy_scene: PackedScene
@export var fireball_scene: PackedScene  # Reference to the fireball scene

# State machine or animation management variables
enum {IDLE, ATTACK, FLYING, HURT, DEATH}
var current_state = IDLE

# Reference to the AnimationPlayer node
var anim_player: AnimationPlayer

func _ready() -> void:
	anim_player = $AnimationPlayer  # Ensure this path matches your scene tree
	play_animation("IDLE")  # Start with the idle animation

	# Setup timers for attacks and enemy spawning
	$Timer.connect("timeout", Callable(self, "_on_attack_timer_timeout"))
	$Timer2.connect("timeout", Callable(self, "_on_spawn_timer_timeout"))
	$Timer.start(attack_cooldown)
	$Timer2.start(spawn_cooldown)

func _on_attack_timer_timeout() -> void:
	long_range_attack()
	$Timer.start(attack_cooldown)

func _on_spawn_timer_timeout() -> void:
	spawn_enemy()
	$Timer2.start(spawn_cooldown)

func long_range_attack() -> void:
	current_state = ATTACK
	play_animation("ATTACK")  # Play attack animation

	# Spawn and configure the fireball
	var fireball = fireball_scene.instantiate()
	fireball.global_position = $Attack_Origin.global_position  # Adjust to match your boss's attack origin point
	fireball.direction = (get_target_position() - global_position).normalized()  # Calculate the direction towards the target
	get_parent().add_child(fireball)  # Add the fireball to the scene

	# Return to idle after the attack animation finishes
	await anim_player.animation_finished
	play_animation("IDLE")
	current_state = IDLE

func spawn_enemy() -> void:
	var enemy = enemy_scene.instantiate()
	enemy.position = $Spawn_Point.global_position
	get_parent().add_child(enemy)

func take_damage(amount: int) -> void:
	current_state = HURT
	play_animation("HURT")

	# After damage animation, return to the appropriate state
	await anim_player.animation_finished
	play_animation("DEATH")
	current_state = IDLE

func die() -> void:
	current_state = DEATH
	play_animation("DEATH")
	await anim_player.animation_finished
	queue_free()

# Animation control function
func play_animation(animation_name: String) -> void:
	if anim_player.current_animation != animation_name:
		anim_player.play(animation_name)

func get_target_position() -> Vector2:
	# Define logic to get the target position (e.g., player's position)
	# Here you can add logic to calculate the player's position or any target you want the boss to aim at
	var player = get_node_or_null("res://scenes/player/player.tscn")  # Replace with your actual player path
	return player.global_position if player else global_position
