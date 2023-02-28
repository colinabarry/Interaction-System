extends Node

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# click screen to capture mouse
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			# release mouse on first esc
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE	
		else:
			# exit game on second esc
			get_tree().quit()
