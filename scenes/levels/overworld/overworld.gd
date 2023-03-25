extends Node


func _ready():
	Global.capture_mouse()

	Global.unpaused.connect(_on_unpaused)


func _on_unpaused():
	Global.capture_mouse()
