extends Node3D

var speech_bubble = (
	preload("res://scenes/user_interfaces/speech_bubble/speech_bubble_3d.tscn").instantiate()
)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test_restart"):
		add_child(speech_bubble)
		speech_bubble.show_dialogue()
