extends StaticBody2D


@onready var message_label = $"../door/doorLabel"
@onready var transition_area = $TransitionArea

var is_door_open = false

func _ready():
	if self.name in Global.opened_doors:
		queue_free()
	$Area2D.connect("body_entered", Callable(self, "_on_transition_area_body_entered"))

func _on_area_2d_body_entered(_body):
	if "KeyA" in Global.key_founded and "KeyB" in Global.key_founded:
		$AnimationPlayer.play("open")
		await $AnimationPlayer.animation_finished
		Global.opened_doors.append(self.name)
		is_door_open = true  
		queue_free()
		get_tree().change_scene_to_file("res://scenes/levels/level_4/lvl4boss_2d.tscn")

	if not self.name in Global.key_founded:
		_show_message("You don't have enough keys!")
		$AnimationPlayer.play("closed")
		
func _on_area_2d_body_exited(_body):
	_hide_message()

func _show_message(text):
	message_label.text = text
	message_label.visible = true

func _hide_message():
	message_label.visible = false



