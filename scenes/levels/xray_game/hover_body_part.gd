class_name HoverBodyPart extends MouseDragHandler

@onready var mesh: MeshInstance3D = $Mesh


func _mouse_enter():
	super()
	mesh.mesh.material.albedo_color.a = 1


func _mouse_exit():
	super()
	mesh.mesh.material.albedo_color.a = 0.39
