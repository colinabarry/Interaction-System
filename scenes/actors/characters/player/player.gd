extends CharacterBody3D

const SPEED = 2.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.1

@export var min_camera_pitch: float = -40
@export var max_camera_pitch: float = 20

var input_dir: Vector2

@onready var camera_origin := $CameraOrigin as Marker3D
@onready var armature := $Armature as Node3D
@onready var animation_tree := $AnimationTree as AnimationTree

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _input(event: InputEvent) -> void:
	# turn camera with mouse
	var camera_rotation: Vector3 = camera_origin.rotation_degrees
	# casting with `as` for precision and to get autocomplete
	var mouse_motion := event as InputEventMouseMotion
	# if cast fails, mouse_motion = null
	if mouse_motion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		camera_rotation.y -= mouse_motion.relative.x * MOUSE_SENSITIVITY
		camera_rotation.x -= mouse_motion.relative.y * MOUSE_SENSITIVITY
	# limit x rotation of camera so it doesn't go wheeeeeeee
	camera_rotation.x = clampf(camera_rotation.x, min_camera_pitch, max_camera_pitch)
	camera_origin.rotation_degrees = camera_rotation

	# jump
	if Input.is_action_just_pressed("move_jump"):
		animation_tree["parameters/OneShot/request"] = true


func _physics_process(delta: float) -> void:
	# add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# get the input direction and handle movement/deceleration.
	input_dir = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	var direction: Vector3 = (
		(camera_origin.transform.basis * Vector3(input_dir.x, 0, -input_dir.y)).normalized()
	)

	# this is a bit verbose
	var blend_position = Vector2()
	blend_position.x = lerp(
		animation_tree["parameters/BlendSpace2D/blend_position"].x, input_dir.x, 0.1
	)
	blend_position.y = lerp(
		animation_tree["parameters/BlendSpace2D/blend_position"].y, input_dir.y, 0.1
	)
	animation_tree["parameters/BlendSpace2D/blend_position"] = blend_position

	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		# lerp the player armature's y rotation toward the camera's y rotation while moving
		armature.rotation.y = lerp_angle(armature.rotation.y, camera_origin.rotation.y, 0.1)
	else:
		# slow down and stop if no input
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# move - this uses `velocity`, which is built-in to CharacterBody3D
	move_and_slide()
