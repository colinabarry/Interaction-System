extends Node

@export var show_frame := true
@export var end_state := Global.PROGRESS_STATE.GAME_STARTED

@onready var frame: Node3D = $Frame
@onready var time_skip: Label = $TimeSkip/Label

var _modulate: Color


func _ready():
	print(Global.progress_state)
	_modulate = time_skip.modulate
	time_skip.modulate = Color.TRANSPARENT

	Global.show_mouse()

	frame.visible = show_frame


func _on_button_pressed() -> void:
	Global.set_progress_state(end_state)
	Global.player_has_control = true
	Global.tween_cubic_modulate(get_parent().get_node_or_null("DoctorDialogue"), Color.TRANSPARENT, 0.4)
	Global.tween_cubic_modulate(get_node("Control"), Color.TRANSPARENT, 0.4)
	Global.transition_rect.fade_out()
	await Global.transition_rect.faded_out

	print(Global.progress_state)
	print(_modulate)
	if Global.progress_state == Global.PROGRESS_STATE.HOSPITAL_COMPLETED:
		skip_time("2-4 Weeks Later")
	# print("hi")
	print(get_tree().change_scene_to_packed(Global.overworld))


func skip_time(text: String) -> void:
	time_skip.text = text
	await Global.tween_cubic_modulate(time_skip, _modulate).finished
	await create_tween().tween_callback(func(): return false).set_delay(1.5).finished
	await Global.tween_cubic_modulate(time_skip).finished
