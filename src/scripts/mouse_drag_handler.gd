class_name MouseDragHandler extends StaticBody3D

var can_drag := false
var is_dragging := false
var mouse_motion: InputEventMouseMotion


# TODO: make the thing only trigger on mouse down so you don't get overlapping mouse drag events
func _process(_delta: float) -> void:
	if can_drag and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		is_dragging = true
	else:  # TODO: go back to the better version of this
		is_dragging = false


func _input(event: InputEvent) -> void:
	mouse_motion = event as InputEventMouseMotion

	if mouse_motion and not Global.is_paused and is_dragging:
		_drag()


## Implement this method. It is called by _input while being dragged.
func _drag() -> void:
	pass


func _mouse_enter() -> void:
	can_drag = true


func _mouse_exit() -> void:
	can_drag = false
