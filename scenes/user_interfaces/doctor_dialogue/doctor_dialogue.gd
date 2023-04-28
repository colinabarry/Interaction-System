@tool
extends DialogueSystem

@onready var cutscene: Cutscene = get_tree().current_scene.get_node_or_null("Cutscene")


func _ready() -> void:
	super()

	options_font_size = 20

	dialogs["start"].connect("after_all", cutscene.resume_animation)


func _input(event: InputEvent) -> void:
	if event.is_pressed() and event.as_text() == "BracketLeft" and not dialog_sequence.cold:
		print("changing sequence")
		hide_options()
		change_sequence(1)

	super(event)
