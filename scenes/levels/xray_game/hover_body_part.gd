class_name HoverBodyPart extends Area3D

# signal body_part_selected(body_part: String)

var selectable := false

@onready var mesh: MeshInstance3D = (
	get_children().filter(func(child): return child is MeshInstance3D).front()
)
@onready var body_part_hints := load("res://scenes/levels/xray_game/body_part_hints.gd")
@onready var hint: Hint = get_tree().current_scene.get_node("Hint")
@onready var doctor_dialogue = get_tree().current_scene.get_node("DoctorDialogue")


func _ready() -> void:
	mesh.mesh.surface_get_material(0).albedo_color.a = 0.39
	create_tween().tween_callback(func(): hint.start_hint_timer(0.001, "")).set_delay(0.5)


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):
		if not selectable:
			return

		# body_part_selected.emit(name)
		hint.text = body_part_hints.hints[name]

		if name == "Anterior Cruciate Ligament":
			mesh.mesh.surface_get_material(0).albedo_color = "ffff00"
			doctor_dialogue.found_acl()
		else:
			mesh.mesh.surface_get_material(0).albedo_color = "9696ff"


func hover() -> void:
	selectable = true
	mesh.mesh.surface_get_material(0).albedo_color.a = 1


func unhover() -> void:
	selectable = false
	mesh.mesh.surface_get_material(0).albedo_color.a = 0.39
