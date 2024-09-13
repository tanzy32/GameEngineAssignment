extends StateBoss

@onready var missile = $"../../Missile"


@export var bullet_node: PackedScene
var can_transition: bool = false

func enter():
	super.enter()
	boss_animation_player.play("ranged_attack")
	await boss_animation_player.animation_finished
	shoot()
	missile.play()
	get_parent().change_state("Follow")

func shoot():
	var bullet = bullet_node.instantiate()
	bullet.position = owner.position  # Make sure 'owner' is the golem

	# Get the direction based on the golem's movement and pass it to the bullet
	var bullet_direction = owner.velocity.normalized()  # Assuming 'owner' refers to the golem
	
	bullet.set_direction(bullet_direction)
	get_tree().current_scene.add_child(bullet)
	

