extends Area2D


signal Is_Active

var is_pressed = false

func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and not is_pressed:
		$AnimationPlayer.play("pressed_button")
		emit_signal("Is_Active")
		is_pressed = true


func _on_area_2d_body_exited(body):
	if body.is_in_group("player") and not is_pressed:
		$AnimationPlayer.play("idle_button")
