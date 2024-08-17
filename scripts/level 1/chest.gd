extends Area2D

@export var potion_drop_chance: float = 1  # 50% chance to drop a potion
@export var potion_scene: PackedScene = load("res://scenes/levels/global/potion.tscn")  # Reference to the potion scene

signal chest_opened  # Signal emitted when the chest is opened

var is_opened: bool = false
var player_nearby: bool = false  # To track if the player is near the chest

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	$Label.hide()  # Hide the interaction label initially

func _on_body_entered(body: Node):
	if body.name == "Player":
		player_nearby = true
		if not is_opened:
			$Label.show()  # Show the interaction label when the player is near

func _on_body_exited(body: Node):
	if body.name == "Player":
		player_nearby = false
		if is_instance_valid($Label):  # Check if the label still exists
			$Label.hide()

func _input(event):
	if player_nearby and not is_opened and event.is_action_pressed("interact"):
		open_chest()

func open_chest():
	is_opened = true
	emit_signal("chest_opened")  # Emit the chest_opened signal
	$AnimatedSprite.play("open") 
	
	await $AnimatedSprite.animation_finished
	
	if randf() <= potion_drop_chance:
		drop_potion()

	 # Play the chest's open animation
	if is_instance_valid($Label):
		$Label.queue_free()  # Remove the interaction label after the chest is opened

func drop_potion():
	# Instantiate and drop the potion at the chest's position
	var potion = potion_scene.instantiate()
	var offset = Vector2(-20, 0)
	potion.position = position + offset
	
	get_parent().add_child(potion)  # Add the potion to the scene tree
