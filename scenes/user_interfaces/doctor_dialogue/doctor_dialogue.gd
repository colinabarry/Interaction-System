@tool
extends DialogueSystem

@onready var cutscene: Cutscene = get_tree().current_scene.get_node_or_null("Cutscene")
@onready var leave_button := $"../GameBase/Control"


func _ready() -> void:
	leave_button.hide()
	super()

	options_font_size = 20

	dialogs["start"].connect("after_all", cutscene.resume_animation)


func found_acl() -> void:
	if dialog_sequence.cold:
		print("changing sequence")
		hide_options()
		change_sequence(1)
		dialog_sequence.connect("dead", leave_button.show)
