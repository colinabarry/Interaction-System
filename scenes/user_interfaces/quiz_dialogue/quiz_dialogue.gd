@tool
extends DialogueSystem

@onready var game_base := $"../GameBase"

var active_sequence := 0


func _ready() -> void:
	super()
	show_box()
	try_begin_dialogue()


# func _on_seq_cold():
# 	super()
# 	active_sequence += 1
# 	active_sequence %= 4
# 	print("CHANGING SEQUENCE")
# 	change_sequence(active_sequence)


func _on_seq_dead():
	super()
	Global.transition_rect.fade_out()
	await Global.transition_rect.faded_out
	await game_base.skip_time("FIN")

	get_tree().change_scene_to_file("res://scenes/user_interfaces/start_menu/start_menu.tscn")
