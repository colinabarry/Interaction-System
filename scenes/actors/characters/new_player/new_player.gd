class_name NewPlayer
extends CharacterBody3D

## Class representing the player
##
## Detailed description? I believe that's what should be here
##
## @tutorial: google.com

const WALK_SPEED := 0.3
const SPRINT_SPEED := 1
const JUMP_VELOCITY := 4.5
const MOUSE_SENSITIVITY := 0.3

@export var min_camera_pitch := -50.0
@export var max_camera_pitch := 30.0

var current_speed: float
var input_dir := Vector2.ZERO
var is_sprinting := false

var speech_bubble = (
	preload("res://scenes/user_interfaces/speech_bubble/speech_bubble_3d.tscn").instantiate()
)

@onready var camera_origin: Marker3D = $CameraOrigin
@onready var armature: Node3D = $Armature
@onready var animation_tree: AnimationTree = $AnimationTree

@onready var speech_bubble_anchor: Node3D = $SpeechBubbleAnchor

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready():
	animation_tree.active = true
	# armature.rotation.y = rotation.y


func _process(_delta):
	if Input.is_action_pressed("move_sprint", true):
		current_speed = SPRINT_SPEED
		if input_dir.length() > 0:
			is_sprinting = true
	else:
		current_speed = WALK_SPEED
		is_sprinting = false


func _input(event: InputEvent) -> void:
	if not Global.player_has_control:
		return

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
	if event.is_action_pressed("move_jump"):
		velocity.y = 1.25
		animation_tree["parameters/OneShot/request"] = true

	if event.is_action_pressed("test_restart"):
		speech_bubble_anchor.add_child(speech_bubble)
		speech_bubble.show_dialogue()


func _physics_process(delta: float) -> void:
	if not Global.player_has_control:
		return

	# add gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# get the input direction and handle movement/deceleration.
	input_dir = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	var direction: Vector3 = (
		(camera_origin.transform.basis * Vector3(input_dir.x, 0, -input_dir.y)).normalized()
	)

	# apply animations based on input direction
	var blend_pos: float = animation_tree["parameters/BlendSpace1D/blend_position"]
	# this should be one of: -1, 0, 1
	var input_dir_y_normalized: float = floor(input_dir.y) if input_dir.y < 0 else ceil(input_dir.y)
	# limit blend_pos to walk if walking
	var blend_target := input_dir_y_normalized if is_sprinting else input_dir_y_normalized / 2
	blend_pos = lerp(blend_pos, blend_target, 0.1)
	animation_tree["parameters/BlendSpace1D/blend_position"] = blend_pos

	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
		# lerp the player armature's y rotation toward the camera's y rotation while moving
		armature.rotation.y = lerp_angle(
			armature.rotation.y, camera_origin.rotation.y - rotation.y, 0.1
		)
	else:
		# slow down and stop if no input
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	# camera_origin is "top level" in order to rotate independently, so the position must be updated manually
	camera_origin.position = lerp(camera_origin.position, position + Vector3(0, 0.25, 0), 0.5)

	# move - this uses `velocity`, which is built-in to CharacterBody3D
	move_and_slide()


func perform_action(action: String):
	match action:
		"jump":
			animation_tree["parameters/OneShot/request"] = true
		_:
			assert(false, "Unknown action: " + action)
