class_name BodyPartPicker extends Area3D

var mouse_position: Vector2
var is_colliding := false
# var collided_area: HoverBodyPart
var collided_parts: Array[HoverBodyPart]

@onready var camera: Camera3D = get_tree().current_scene.get_node("GameBase/Camera")


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_position = get_viewport().get_mouse_position()
		position = camera.project_ray_origin(mouse_position)


func sort_by_world_z(a: HoverBodyPart, b: HoverBodyPart) -> bool:
	var a_mesh = a.get_children().filter(func(child): return child is MeshInstance3D).front()
	var b_mesh = b.get_children().filter(func(child): return child is MeshInstance3D).front()
	return a_mesh.global_position.z > b_mesh.global_position.z


func _on_area_entered(area: Area3D) -> void:
	if area is HoverBodyPart:
		is_colliding = true
		collided_parts.push_front(area)

		collided_parts.sort_custom(sort_by_world_z)

		collided_parts[0].hover()
		if collided_parts.size() > 1:
			collided_parts[1].unhover()


func _on_area_exited(area: Area3D) -> void:
	if area is HoverBodyPart:
		if collided_parts.size() == 0:
			is_colliding = false

		area.unhover()
		collided_parts.erase(area)
		if collided_parts.size() > 0:
			collided_parts[0].hover()
