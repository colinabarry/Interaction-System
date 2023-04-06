extends StaticBody3D

@export var max_camera_position_x := 4.0
@export var max_camera_position_y := 2.3

var can_drag := false
var is_dragging := false

@onready var render_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var render_height: int = ProjectSettings.get_setting("display/window/size/viewport_height")
@onready var starting_position := position


func _process(_delta: float) -> void:
	if can_drag and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		is_dragging = true
	if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		is_dragging = false


func _input(event: InputEvent) -> void:
	var mouse_motion := event as InputEventMouseMotion

	if mouse_motion and not Global.is_paused and is_dragging:
		# var mouse_x := mouse_motion.position.x
		# var mouse_y := mouse_motion.position.y

		position.x += remap(
			mouse_motion.relative.x,
			-render_width / 2,
			render_width / 2,
			-max_camera_position_x,
			max_camera_position_x
		)
		position.y += remap(
			mouse_motion.relative.y,
			render_height / 2,
			-render_height / 2,
			-max_camera_position_y,
			max_camera_position_y
		)
		# position.x = remap(mouse_x, 0, render_width, -max_camera_position_x, max_camera_position_x)
		# position.y = remap(mouse_y, 0, render_height, min_camera_position_y, max_camera_position_y)
		# print(position)
		print(mouse_motion.relative)


func _on_mouse_entered() -> void:
	can_drag = true


func _on_mouse_exited() -> void:
	can_drag = false
