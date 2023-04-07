extends MouseDragHandler

# TODO: Make this not (somewhat) arbitrary
@export var max_camera_position_x := 4.0
@export var max_camera_position_y := 2.3

@onready var render_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var render_height: int = ProjectSettings.get_setting("display/window/size/viewport_height")


func _input(event: InputEvent) -> void:
	super(event)
	var event_mouse_button := event as InputEventMouseButton

	if not event_mouse_button:
		return
	if not event_mouse_button.pressed:
		return

	match event_mouse_button.button_index:
		MOUSE_BUTTON_WHEEL_DOWN:
			print("scrolled down")
			if scale > Vector3(0.5, 0.5, 0.5):
				scale -= Vector3(0.5, 0.5, 0.5)
		MOUSE_BUTTON_WHEEL_UP:
			print("scrolled up")
			if scale < Vector3(10, 10, 10):
				scale += Vector3(0.5, 0.5, 0.5)


func _drag():
	rotate_y(
		remap(
			mouse_motion.relative.x,
			-render_width / 2,
			render_width / 2,
			-max_camera_position_x,
			max_camera_position_x
		)
	)
