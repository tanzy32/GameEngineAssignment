extends Area2D

@onready var timer = $Timer #drag from left and hold control while release



func _on_body_entered(body):
	print("You died!")
	Engine.time_scale = 0.5 #slow motion the game by half 
	body.get_node("CollisionShape2D").queue_free() #remove body node in screen
	timer.start()


func _on_timer_timeout():
	Engine.time_scale = 1 #reset 
	get_tree().reload_current_scene() #get scene tree, then reload current scene
