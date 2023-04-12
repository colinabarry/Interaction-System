extends Node3D

const RAY_LENGTH = 10.0

var last_result := {}


func _physics_process(_delta: float) -> void:
	var space_state := get_world_3d().direct_space_state
	var camera := $GameBase/Camera
	var mouse_position := get_viewport().get_mouse_position()
	var from: Vector3 = camera.project_ray_origin(mouse_position)
	var to: Vector3 = from + camera.project_ray_normal(mouse_position) * RAY_LENGTH
	var collision_mask := 0b1000
	var query := PhysicsRayQueryParameters3D.create(from, to, collision_mask)

	var result := space_state.intersect_ray(query)
	# TODO: do some kind of mouse_enter, mouse_exit logic on this stuff
	# potentially switching to a long ol cylinder or line or something to just be able to use entered and exited signals hmmmm...

	if result.collider is HoverBodyPart:
		pass
