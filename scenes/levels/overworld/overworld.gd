extends Node


func _ready():
	Global.capture_mouse()

	Global.player_has_control = true
	Global.set_is_in_minigame(false)

	Global.unpaused.connect(_on_unpaused)


func _on_unpaused():
	Global.capture_mouse()
