extends TextureRect

var blur_amount := 2.0


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS


func show_menu() -> void:
	Global.show_mouse()

	var tween := create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

	visible = true
	# fade menu in
	tween.tween_property(self, "modulate", Color.WHITE, 0.25)
	# blur bg
	tween.tween_property(self.get_material(), "shader_parameter/amount", blur_amount, 0.25)


func hide_menu() -> void:
	var tween := create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC)
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

	# fade menu out
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.25)
	# un-blur bg
	tween.tween_property(self.get_material(), "shader_parameter/amount", 0.0, 0.25)

	await tween.finished
	visible = false


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_resume_pressed() -> void:
	Global.resume()


func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/user_interfaces/start_menu/start_menu.tscn")
	Global.resume() # TODO: GIVE MOUSE CONTROL BACK
