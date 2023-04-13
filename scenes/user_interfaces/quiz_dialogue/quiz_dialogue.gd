@tool
extends DialogueSystem
<<<<<<< Updated upstream
=======

var active_sequence := 0


func _ready() -> void:
	super()
	show_box()
	try_begin_dialogue()


func _on_seq_cold():
	super()
	active_sequence += 1
	active_sequence %= 4
	print("CHANGING SEQUENCE")
	change_sequence(active_sequence)
>>>>>>> Stashed changes
