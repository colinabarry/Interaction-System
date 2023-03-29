@tool
extends DialogueSystem


func _input(event: InputEvent) -> void:
	if event.is_pressed() and event.as_text() == "BracketLeft" and not dialog_sequence.cold:
		print("changing sequence")
		hide_options()
		change_sequence(1)

	super(event)
