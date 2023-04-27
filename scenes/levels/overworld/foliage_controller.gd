@tool
class_name FoliageController extends Node3D

@export var use_high_fidelity_trees := false:
	set(val):
		use_high_fidelity_trees = val
		_update()

@onready var high_fidelity_trees: Node3D = $"Scatterers/HighFidelity"
@onready var low_fidelity_trees: Node3D = $"Scatterers/LowFidelity"


func _update():
	high_fidelity_trees.visible = use_high_fidelity_trees
	low_fidelity_trees.visible = not use_high_fidelity_trees
