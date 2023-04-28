@tool
class_name FoliageController extends Node3D

@export var use_high_fidelity_trees := true:
	set(val):
		use_high_fidelity_trees = val
		_update()

@onready var high_fidelity_trees: Node3D = $"Scatterers/HighFidelity"
@onready var low_fidelity_trees: Node3D = $"Scatterers/LowFidelity"


func _ready() -> void:
	use_high_fidelity_trees = Settings.high_fidelity_trees_enabled

	Settings.high_fidelity_trees_toggled.connect(func(val): use_high_fidelity_trees = val)


func _update() -> void:
	high_fidelity_trees.visible = use_high_fidelity_trees
	low_fidelity_trees.visible = not use_high_fidelity_trees
