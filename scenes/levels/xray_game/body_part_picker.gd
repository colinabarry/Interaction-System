class_name BodyPartPicker extends Area3D

var mouse_position: Vector2

@onready var camera: Camera3D = get_tree().current_scene.get_node("GameBase/Camera")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_position = get_viewport().get_mouse_position()
		position = camera.project_ray_origin(mouse_position)
