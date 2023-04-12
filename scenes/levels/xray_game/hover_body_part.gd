class_name HoverBodyPart extends MouseDragHandler

@onready var mesh: MeshInstance3D = (
	get_children().filter(func(child): return child is MeshInstance3D).front()
)


func _ready() -> void:
	mesh.mesh.surface_get_material(0).albedo_color.a = 0.39


func highlight() -> void:
	mesh.mesh.surface_get_material(0).albedo_color.a = 1


func un_highlight() -> void:
	mesh.mesh.surface_get_material(0).albedo_color.a = 0.39

# func _mouse_enter():
# 	super()
# 	mesh.mesh.surface_get_material(0).albedo_color.a = 1

# func _mouse_exit():
# 	super()
# 	mesh.mesh.surface_get_material(0).albedo_color.a = 0.39
