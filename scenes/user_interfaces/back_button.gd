extends Button


func _ready() -> void:
	Global.transition_rect.fade_in()


func _on_pressed() -> void:
	Global.transition_rect.fade_out()
	await Global.transition_rect.faded_out
	get_tree().change_scene_to_file("scenes/user_interfaces/start_menu/start_menu.tscn")
