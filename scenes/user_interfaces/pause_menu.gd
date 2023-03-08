extends TextureRect

# func _ready():
# 	modulate = Color.TRANSPARENT

# func pause() -> void:
# 	is_paused = true

# 	pause_menu.show_menu()

# 	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
# 		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# func resume() -> void:
# 	is_paused = false

# 	pause_menu.hide_menu()

# 	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
# 		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func show_menu() -> void:
	var tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC)

	# fade menu in
	tween.tween_property(self, "modulate", Color.WHITE, 0.25)
	# blur bg
	tween.tween_property(self.get_material(), "shader_parameter/amount", 1.5, 0.25)


func hide_menu() -> void:
	var tween = get_tree().create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC)

	# fade menu out
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.25)
	# un-blur bg
	tween.tween_property(self.get_material(), "shader_parameter/amount", 0.0, 0.25)


func _on_quit_pressed() -> void:
	get_tree().quit()
