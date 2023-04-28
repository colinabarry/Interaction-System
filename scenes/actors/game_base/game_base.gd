extends Node

@export var show_frame := true
@export var end_state := Global.PROGRESS_STATE.GAME_STARTED

@onready var frame: Node3D = $Frame
@onready var time_skip: Label = $TimeSkip/Label
@onready var leave_button := $Control/MarginContainer/Button

var _modulate: Color


func _ready():
	print(Global.progress_state)
	_modulate = time_skip.modulate
	time_skip.modulate = Color.TRANSPARENT

	Global.show_mouse()

	frame.visible = show_frame

	leave_button.pressed.connect(leave_scene)


func leave_scene() -> void:
	Global.set_progress_state(end_state)
	Global.player_has_control = true
	# Global.tween_cubic_modulate(
	# 	get_parent().get_node_or_null("DoctorDialogue"), Color.TRANSPARENT, 0.4
	# )
	# Global.tween_cubic_modulate(get_node("Control"), Color.TRANSPARENT, 0.4)
	Global.transition_rect.fade_out()
	await Global.transition_rect.faded_out

	print("STATE:", Global.progress_state)
	print(_modulate)
	if Global.progress_state == Global.PROGRESS_STATE.HOSPITAL_COMPLETED:
		skip_time("2-4 Weeks Later")
	# print("hi")
	print(get_tree().change_scene_to_packed(Global.overworld))


func skip_time(text: String) -> void:
	time_skip.text = text

	await (
		create_tween()
		. tween_callback(func(): await Global.tween_cubic_modulate(time_skip, _modulate).finished)
		. set_delay(1.5)
		. finished
		. connect(func(): await Global.tween_cubic_modulate(time_skip).finished)
	)
