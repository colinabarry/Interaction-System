extends Node

@export var show_frame := true
@export var end_state := Global.PROGRESS_STATE.GAME_STARTED

@onready var frame: Node3D = $Frame
@onready var time_skip: Label = $TimeSkip/Label

var _modulate


func _ready():
	
	_modulate = time_skip.modulate
	time_skip.modulate = Color.TRANSPARENT
	
	Global.show_mouse()
	
	frame.visible = show_frame


func _on_button_pressed() -> void:
	Global.set_progress_state(end_state)
	Global.player_has_control = true
	Global.transition_rect.fade_out()
	await Global.transition_rect.faded_out
	
	print(Global.progress_state)
	if Global.progress_state == Global.PROGRESS_STATE.HOSPITAL_COMPLETED:
		await Global.tween_cubic_modulate(time_skip, _modulate).finished
		await create_tween().tween_callback(func(): return false).set_delay(1.5).finished
		await Global.tween_cubic_modulate(time_skip).finished
	print("hi")
	print(get_tree().change_scene_to_packed(Global.overworld))
