extends Node

@onready var leave_button := $GameBase/Control


func _ready() -> void:
	leave_button.hide()
	Global.transition_rect.fade_in()
