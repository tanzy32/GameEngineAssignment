class_name BaseScene extends Node2D

@onready var player: MyPlayer = $Player
@onready var entrance_markers: Area2D = $PortalEntrance
@onready var playerui = player.get_child(-1)

var has_last_scene: bool = false

func _ready():
	pass

