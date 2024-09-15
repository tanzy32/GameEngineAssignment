extends Area2D


@onready var activator = $Sprite2D
@onready var label = $Label
@onready var tilemap = $"../../../LevelStructure"
@onready var easyhitboxes = $"../../../LevelStructure/EasyHitBox".get_children()
@onready var hardhitboxes = $"../../../LevelStructure/HardHitBox".get_children()
@onready var platforms = $"../../../Platforms"
@onready var easytimer = $EasyTimer
@onready var hardtimer = $"../../../LevelStructure/HardTimer"
@onready var cooldowntimer = $"../../../LevelStructure/HardTimer/Cooldown"

var player_nearby: bool = false 
var is_activate_waterlever: bool = false
var is_activate_platformlever: bool = false
var activator_number: int
var can_interact_with_platform: bool = false  # Allow interaction after platform finishes moving
var can_interact_with_water: bool = false  # Allow interaction after water timer finishes

func _ready():
	label.hide()  # Hide the interaction label initially
	for j in hardhitboxes:
		j.disabled = true
			
func _on_water_activator_body_entered(body: Node):
	if body is CharacterBody2D:
		player_nearby = true
		if !is_activate_waterlever:
			can_interact_with_water = true
			label.show()

func _on_water_activator_body_exited(body: Node):
	if body is CharacterBody2D:
		player_nearby = false
		label.hide()

func _input(event):
	if player_nearby and event.is_action_pressed("interact"):
		if !is_activate_platformlever and activator_number > 0 and can_interact_with_platform:
			is_activate_platformlever = true
			activator.flip_h = true
			move_platform(activator_number)
		if !is_activate_waterlever and can_interact_with_water:
			is_activate_waterlever = true
			activator.flip_h = true
			change_water()
			
		
func move_platform(number: int):
	label.hide()
	var platform = platforms.get_child(0)
	can_interact_with_platform = false  # Disable interaction until platform finishes moving
	platform.get_child(number - 1).play("move")

	is_activate_platformlever = false
	activator.flip_h = true
	
func _on_platform_activator_body_P1_entered(body):
	if body is CharacterBody2D:
		player_nearby = true
		if !is_activate_platformlever: 
			can_interact_with_platform = true
			activator_number = 1
			label.show()


func _on_platform_activator_body_P1_exited(body):
	if body is CharacterBody2D:
		player_nearby = false
		label.hide()
		activator_number = 0

func _on_platform_activator_body_P2_entered(body):
	if body is CharacterBody2D:
		player_nearby = true
		if !is_activate_platformlever: 
			can_interact_with_platform = true
			activator_number = 2
			label.show()

func _on_platform_activator_body_P2_exited(body):
	if body is CharacterBody2D:
		player_nearby = false
		label.hide()
		activator_number = 0

func _on_platform_activator_body_P3_entered(body):
	if body is CharacterBody2D:
		player_nearby = true
		if !is_activate_platformlever: 
			can_interact_with_platform = true
			activator_number = 3
			label.show()
		
func _on_platform_activator_body_P3_exited(body):
	if body is CharacterBody2D:
		player_nearby = false
		label.hide()
		activator_number = 0


func _on_platform_activator_body_P4_entered(body):
	if body is CharacterBody2D:
		player_nearby = true
		if !is_activate_platformlever: 
			can_interact_with_platform = true
			activator_number = 4
			label.show()
		
func _on_platform_activator_body_P4_exited(body):
	if body is CharacterBody2D:
		player_nearby = false
		label.hide()
		activator_number = 0

func change_water():
	label.hide()
	for i in range(0, 4):
		var tile_data: TileData = tilemap.get_cell_tile_data(1, Vector2(i, -153))
		tile_data.set_modulate(Color(1, 1, 1, 1))
		for j in easyhitboxes:
			j.disabled = true
	easytimer.start()
	can_interact_with_water = false  # Disable interaction until easytimer finishe
	
func _on_easytimer_timeout():
	for i in range(0, 4):
		var tile_data: TileData = tilemap.get_cell_tile_data(1, Vector2(i, -153))
		tile_data.set_modulate(Color("00dd00"))
		for j in easyhitboxes:
			j.disabled = false
	is_activate_waterlever = false
	activator.flip_h = false
	
			
func _on_hardtimer_timeout():
	for i in range(4, 8):
		var tile_data: TileData = tilemap.get_cell_tile_data(1, Vector2(i, -153))
		tile_data.set_modulate(Color("00dd00"))
		for j in hardhitboxes:
			j.disabled = false
	cooldowntimer.start()

func _on_cooldown_timeout():
	reset_water()
	
func reset_water():	
	for i in range(4,8):
		var tile_data:TileData = tilemap.get_cell_tile_data(1, Vector2(i,-153))
		tile_data.set_modulate(Color(1,1,1,1))
		for j in hardhitboxes:
			j.disabled = true
	hardtimer.start()
			




