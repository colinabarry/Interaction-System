extends Node3D

@onready var speech_bubble := $SpeechBubble3D


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test_restart"):
		speech_bubble.show_box()
		speech_bubble.try_begin_dialogue()
