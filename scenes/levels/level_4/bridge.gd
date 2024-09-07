extends Node2D  # or AnimatedSprite2D if you are using this node type


func _on_lever_switch_is_active():
	$AnimationPlayer.play("open")
