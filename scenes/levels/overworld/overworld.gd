extends Node


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	Global.unpaused.connect(_on_unpaused)


func _on_unpaused():
	Global.capture_mouse()
