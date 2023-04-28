@tool
extends DialogueSystem

@onready var cutscene: Cutscene = get_tree().current_scene.get_node_or_null("Cutscene")
@onready var game_base := $"../GameBase"


func _init() -> void:
	super()
	Global.player_has_control = false


func _ready() -> void:
	super()

	# dialogs["start"].connect("after_all", cutscene.resume_animation)
	dialog_sequence.connect("dead", skip_time)


func skip_time() -> void:
	await game_base.skip_time("5-7 Months Later")

	change_sequence(1)
	dialog_sequence.connect("dead", cutscene.resume_animation)
	show_box()
	try_begin_dialogue()
