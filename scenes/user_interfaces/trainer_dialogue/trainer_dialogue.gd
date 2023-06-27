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
	Global.transition_rect.fade_out()
	await Global.transition_rect.faded_out
	await game_base.skip_time("1-2 Months Later")
	Global.transition_rect.fade_in()
	await Global.transition_rect.faded_in
	"""
func skip_time2() -> void:
	Global.transition_rect.fade_out()
	await Global.transition_rect.faded_out
	await game_base.skip_time2("3-5 Months Later")
	Global.transition_rect.fade_in()
	await Global.transition_rect.faded_in
	
func skip_time3() -> void:
	Global.transition_rect.fade_out()
	await Global.transition_rect.faded_out
	await game_base.skip_time3("5-7 Months Later")
	Global.transition_rect.fade_in()
	await Global.transition_rect.faded_in
	
func skip_time4() -> void:
	Global.transition_rect.fade_out()
	await Global.transition_rect.faded_out
	await game_base.skip_time4("7-9 Months Later")
	Global.transition_rect.fade_in()
	await Global.transition_rect.faded_in
"""
	change_sequence(1)
	dialog_sequence.connect("dead", cutscene.resume_animation)
	show_box()
	try_begin_dialogue()
