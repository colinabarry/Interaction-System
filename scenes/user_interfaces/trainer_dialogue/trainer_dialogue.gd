@tool
extends DialogueSystem

@onready var cutscene: Cutscene = get_tree().current_scene.get_node_or_null("Cutscene")


func _ready() -> void:
	super()

	dialogs["start"].connect("after_all", cutscene.resume_animation)
