extends TextureRect

var blur_amount := 3.0


func show_menu() -> void:
	var tween := get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC)

	# fade menu in
	tween.tween_property(self, "modulate", Color.WHITE, 0.25)
	# blur bg
	tween.tween_property(self.get_material(), "shader_parameter/amount", blur_amount, 0.25)


func hide_menu() -> void:
	var tween := get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC)

	# fade menu out
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.25)
	# un-blur bg
	tween.tween_property(self.get_material(), "shader_parameter/amount", 0.0, 0.25)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_resume_pressed() -> void:
	Global.resume()
