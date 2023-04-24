@tool
class_name StreetLightController extends Node3D

@onready var street_lights := get_children()

@export var all_lit := false:
	set(val):
		all_lit = val
		_update()

# func _ready() -> void:
# 	_update()


func _update() -> void:
	for light in street_lights:
		light.lit = all_lit
