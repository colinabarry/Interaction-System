extends Node

@export var max_camera_position_x := 5.0
@export var max_camera_position_y := 3.0

@onready var xray_camera: Node3D = $XRayCamera

@onready var render_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var render_height: int = ProjectSettings.get_setting("display/window/size/viewport_height")
@onready var starting_position := xray_camera.position


func _input(event):
	var mouse_motion := event as InputEventMouseMotion

	if mouse_motion and not Global.is_paused:
		var mouse_x := mouse_motion.position.x
		var mouse_y := mouse_motion.position.y

		xray_camera.position.x = remap(
			mouse_x,
			0,
			render_width,
			-max_camera_position_x + starting_position.x,
			max_camera_position_x + starting_position.x
		)
		xray_camera.position.y = remap(
			mouse_y,
			0,
			render_height,
			max_camera_position_y + starting_position.y,
			-max_camera_position_y + starting_position.y
		)
