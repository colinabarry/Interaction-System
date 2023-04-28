@tool
extends DialogueSystem

@onready var cutscene: Cutscene = get_tree().current_scene.get_node_or_null("Cutscene")
@onready var leave_button := $"../GameBase/Control"


func _ready() -> void:
	leave_button.hide()
	super()

	options_font_size = 20

	dialogs["start"].connect("after_all", cutscene.resume_animation)
	dialog_sequence.connect("dead", func():
		change_sequence(1)
		show_box()
		try_begin_dialogue()
		)


func found_acl() -> void:
	print("changing sequence")
	hide_options()
	change_sequence(2)
	dialog_sequence.connect("dead", func():
		leave_button.show()
		change_sequence(1)
		show_box()
		try_begin_dialogue()
		)
	show_box()
	try_begin_dialogue()
