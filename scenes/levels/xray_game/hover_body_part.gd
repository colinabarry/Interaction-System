class_name HoverBodyPart extends Area3D

var selected := false

@onready var mesh: MeshInstance3D = (
	get_children().filter(func(child): return child is MeshInstance3D).front()
)


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

	mesh.mesh.surface_get_material(0).albedo_color.a = 0.39


func _hover() -> void:
	mesh.mesh.surface_get_material(0).albedo_color.a = 1


func _unhover() -> void:
	mesh.mesh.surface_get_material(0).albedo_color.a = 0.39


func _on_area_entered(area: Area3D) -> void:
	# print(area.name, " entered ", name)
	if area is BodyPartPicker:
		_hover()


func _on_area_exited(area: Area3D) -> void:
	# print(area.name, " exited ", name)
	if area is BodyPartPicker:
		_unhover()
