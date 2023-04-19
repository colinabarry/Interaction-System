extends MouseDragHandler

var current_player := "Megan"

@onready
var xray_bot: StaticBody3D = get_tree().current_scene.get_node_or_null("XRay" + current_player)

# TODO: Uhhhhh this is basically copy+pasted from x_ray_camera.gd
# TODO: Make this not (somewhat) arbitrary
@export var max_camera_position_x := 4.0
@export var max_camera_position_y := 2.3

@onready var render_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var render_height: int = ProjectSettings.get_setting("display/window/size/viewport_height")


func _drag():
	xray_bot.position.x += remap(
		mouse_motion.relative.x,
		-render_width / 2,
		render_width / 2,
		-max_camera_position_x,
		max_camera_position_x
	)
	xray_bot.position.y += remap(
		mouse_motion.relative.y,
		render_height / 2,
		-render_height / 2,
		-max_camera_position_y,
		max_camera_position_y
	)
