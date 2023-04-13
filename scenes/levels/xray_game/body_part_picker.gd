class_name BodyPartPicker extends Area3D

var mouse_position: Vector2
var is_colliding := false
var collided_area: HoverBodyPart

@onready var camera: Camera3D = get_tree().current_scene.get_node("GameBase/Camera")


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_position = get_viewport().get_mouse_position()
		position = camera.project_ray_origin(mouse_position)


func _on_area_entered(area: Area3D) -> void:
	if is_colliding:
		return

	if area is HoverBodyPart:
		is_colliding = true
		collided_area = area
		collided_area.hover()


func _on_area_exited(area: Area3D) -> void:
	if area == collided_area:
		is_colliding = false
		collided_area = null
		area.unhover()
