extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("buttonUp")
	$AnimationPlayer.play("doorClosed")

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		$AnimationPlayer.play("buttonDown")
		$AnimationPlayer.play("doorOpen")
