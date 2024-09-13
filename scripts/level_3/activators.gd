extends Area2D


@onready var activator = $Sprite2D
@onready var label = $Label
@onready var tilemap = $"../../../Level Background"
@onready var easyhitboxes = $"../../../Level Background/easyhitBox".get_children()
@onready var hardhitboxes = $"../../../Level Background/hardhitBox".get_children()
@onready var platforms = $"../../../Platforms"
@onready var easytimer = $"../../../Level Background/easytimer"
@onready var hardtimer = $"../../../Level Background/hardtimer"
@onready var cooldowntimer = $"../../../Level Background/hardtimer/cooldown"

var player_nearby: bool = false 
var is_activate_waterlever: bool = false
var is_activate_platformlever: bool = false
var activator_number: int

func _ready():
	label.hide()  # Hide the interaction label initially
	for j in hardhitboxes:
			j.disabled = true
func _on_water_activator_body_entered(body: Node):
	if body is CharacterBody2D:
		is_activate_waterlever = true
		player_nearby = true
		label.show() 

func _on_water_activator_body_exited(body: Node):
	if body is CharacterBody2D:
		is_activate_waterlever = false
		player_nearby = false
		if is_instance_valid(label): 
			label.hide()

func _input(event):
	if player_nearby and event.is_action_pressed("interact") and is_activate_platformlever:
		$Open.play()
		move_platform(activator_number)
	if player_nearby and event.is_action_pressed("interact") and is_activate_waterlever:
		$Open.play()
		change_water()
		
func move_platform(number: int):
	var platform = platforms.get_child(0)
	platform.get_child(number - 1).play("move")

func _on_platform_activator_body_P1_entered(body):
	if body is CharacterBody2D:
		is_activate_platformlever = true
		player_nearby = true
		activator_number = 1
		label.show() 


func _on_platform_activator_body_P1_exited(body):
	if body is CharacterBody2D:
		is_activate_platformlever = false
		player_nearby = false
		activator_number = 0
		if is_instance_valid(label): 
			label.hide()

func _on_platform_activator_body_P2_entered(body):
	if body is CharacterBody2D:
		is_activate_platformlever = true
		player_nearby = true
		activator_number = 2
		label.show() 


func _on_platform_activator_body_P2_exited(body):
	if body is CharacterBody2D:
		is_activate_platformlever = false
		player_nearby = false
		activator_number = 0
		if is_instance_valid(label): 
			label.hide()

func _on_platform_activator_body_P3_entered(body):
	if body is CharacterBody2D:
		is_activate_platformlever = true
		player_nearby = true
		activator_number = 3
		label.show() 
		
func _on_platform_activator_body_P3_exited(body):
	if body is CharacterBody2D:
		is_activate_platformlever = false
		player_nearby = false
		activator_number = 0
		if is_instance_valid(label): 
			label.hide()


func _on_platform_activator_body_P4_entered(body):
	if body is CharacterBody2D:
		is_activate_platformlever = true
		player_nearby = true
		activator_number = 4
		label.show() 
		
func _on_platform_activator_body_P4_exited(body):
	if body is CharacterBody2D:
		is_activate_platformlever = false
		player_nearby = false
		activator_number = 0
		if is_instance_valid(label): 
			label.hide()

func change_water():
	for i in range(0,4):
		var tile_data:TileData = tilemap.get_cell_tile_data(1, Vector2(i,-153))
		tile_data.set_modulate(Color(1,1,1,1))
		for j in easyhitboxes:
			j.disabled = true
	easytimer.start()

func _on_easytimer_timeout():
	for i in range(0,4):
		var tile_data:TileData = tilemap.get_cell_tile_data(1, Vector2(i,-153))
		tile_data.set_modulate(Color("00dd00"))
		for j in easyhitboxes:
			j.disabled = false
			
func _on_hardtimer_timeout():
	for i in range(4,8):
		var tile_data:TileData = tilemap.get_cell_tile_data(1, Vector2(i,-153))
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
			




