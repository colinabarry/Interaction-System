@tool
class_name StreetLight extends Node3D

@export var lit := false:
	set(val):
		lit = val
		_update()

@onready var light1: OmniLight3D = $Light1
@onready var light2: OmniLight3D = $Light2


func _ready() -> void:
	_update()


# func _process(_delta: float) -> void:
# 	if Engine.is_editor_hint():
# 		if get_parent() is StreetLightController:
# 			print("really")
# 			lit = get_parent().all_lit
# 			_update()


func _update() -> void:
	light1.visible = lit
	light2.visible = lit
