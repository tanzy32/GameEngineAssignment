extends Area2D

# Signal for body entering area


func _on_body_entered(body):
	if body is Player: 
		body.handle.danger()
