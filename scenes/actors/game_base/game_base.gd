extends Node

@export var show_frame := true
@export var end_state := Global.PROGRESS_STATE.GAME_STARTED

@onready var frame: Node3D = $Frame
@onready var overworld := preload("res://scenes/levels/overworld/overworld.tscn")


func _ready():
	Global.show_mouse()

	frame.visible = show_frame


func _on_button_pressed() -> void:
	Global.set_progress_state(end_state)
	Global.player_has_control = true
	get_tree().change_scene_to_packed(overworld)
