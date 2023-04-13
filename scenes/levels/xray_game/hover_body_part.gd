class_name HoverBodyPart extends Area3D

var selectable := false
var selected := false

@onready var mesh: MeshInstance3D = (
	get_children().filter(func(child): return child is MeshInstance3D).front()
)
@onready var hint: Hint = get_tree().current_scene.get_node("Hint")


func _ready() -> void:
	mesh.mesh.surface_get_material(0).albedo_color.a = 0.39


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):
		if not selectable:  # FIXME: make the selected things stay selected until you click outside of them
			selected = false
			mesh.mesh.surface_get_material(0).albedo_color.a = 0.39
		else:
			selected = true
			mesh.mesh.surface_get_material(0).albedo_color.a = 1
			hint.hint_text = "You found the " + name + "!"


func hover() -> void:
	selectable = true
	mesh.mesh.surface_get_material(0).albedo_color.a = 1


func unhover() -> void:
	selectable = false
	mesh.mesh.surface_get_material(0).albedo_color.a = 0.39
