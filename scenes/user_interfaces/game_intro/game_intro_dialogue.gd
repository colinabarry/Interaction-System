@tool
extends DialogueSystem

@onready var cutscene: Cutscene = get_tree().current_scene.get_node_or_null("Cutscene")

var dialog_sequence_idx := 0


func _ready():
	super()

	connect("dialog_sequence_changed", increment_seq_idx)

	dialog_sequence.connect("dead", cutscene.resume_animation)


# super scuffed but whatever
func increment_seq_idx():
	dialog_sequence_idx += 1

	if dialog_sequence_idx == 1:
		# dialogs["n_post_tear"].connect("after_all", cutscene.resume_animation)  #
		dialog_sequence.connect("dead", cutscene.resume_animation)
