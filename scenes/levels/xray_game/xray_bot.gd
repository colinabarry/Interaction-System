extends MouseDragHandler

# TODO: Make this not (somewhat) arbitrary
@export var max_camera_position_x := 4.0
@export var max_camera_position_y := 2.3
@export var min_player_size := 0.5 * Vector3.ONE
@export var max_player_size := 10 * Vector3.ONE
@export var player_size_increment := 0.5 * Vector3.ONE

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
			if scale > min_player_size:
				scale -= player_size_increment
		MOUSE_BUTTON_WHEEL_UP:
			if scale < max_player_size:
				scale += player_size_increment


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
