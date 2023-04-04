@tool
extends DialogueSystem

@onready var cutscene := get_tree().current_scene.get_node_or_null("Cutscene")


func _ready():
	super()

	dialogs["p_d_1"].connect("before_all", cutscene.resume_animation)  # player falls down, blows out ACL
	dialogs["p_t_2"].connect("after_all", cutscene.resume_animation)  # player calls for help
	dialogs["p_d_2"].connect("after_all", load_hospital)  # transition to doctor


func load_hospital():
	get_tree().change_scene_to_file("scenes/levels/xray_game/xray_game.tscn")
