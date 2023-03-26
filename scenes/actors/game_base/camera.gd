extends Camera3D

@export var max_camera_rotation_x := 0.01
@export var max_camera_rotation_y := 0.01
@export var max_camera_position_x := 0.1
@export var max_camera_position_y := 0.1

@onready var render_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var render_height: int = ProjectSettings.get_setting("display/window/size/viewport_height")
@onready var starting_position := position


func _input(event):
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	var mouse_motion := event as InputEventMouseMotion

	if mouse_motion and not Global.is_paused:
		var mouse_x := mouse_motion.position.x
		var mouse_y := mouse_motion.position.y

		rotation.y = remap(mouse_x, 0, render_width, max_camera_rotation_x, -max_camera_rotation_x)
		rotation.x = remap(mouse_y, 0, render_height, max_camera_rotation_y, -max_camera_rotation_y)

		position.x = remap(
			mouse_x,
			0,
			render_width,
			-max_camera_position_x + starting_position.x,
			max_camera_position_x + starting_position.x
		)
		position.y = remap(
			mouse_y,
			0,
			render_height,
			max_camera_position_y + starting_position.y,
			-max_camera_position_y + starting_position.y
		)
