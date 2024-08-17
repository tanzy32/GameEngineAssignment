class_name Potion
extends Area2D

signal potion_picked_up

var player_nearby: bool = false
var player = MyPlayer
@export var item: InventoryItem

func _ready():
	player = MyPlayer.new()
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))
	$Label.hide()

func _on_body_entered(body: Node):
	if body.name == "Player":
		player_nearby = true
		$Label.show()

func _on_body_exited(body: Node):
	if body.name == "Player":
		player_nearby = false
		$Label.hide()

func collect(inventory: Inventory):
	inventory.insert(item)
	queue_free()

