extends Node

signal paused
signal unpaused
signal progress_advanced(new_progress_state: int)

## This enum is named so that it can be used to populate export variable dropdowns, ex:
## @export var end_state := Global.PROGRESS_STATE.GAME_STARTED
enum PROGRESS_STATE {
	GAME_STARTED,
	HOSPITAL_ENTERED,
	HOSPITAL_COMPLETED,
	GYM_ENTERED,
	GYM_COMPLETED,
	HOME_ENTERED,
	HOME_COMPLETED,
	GAME_COMPLETED,
}

var is_paused := false
var player_has_control := true:
	set = _set_player_has_control,
	get = _get_player_has_control
var progress_state: int = PROGRESS_STATE.GAME_STARTED

var pause_menu: TextureRect = (
	preload("res://scenes/user_interfaces/pause_menu/pause_menu.tscn").instantiate()
)
var transition_rect: TransitionArea = (
	preload("res://scenes/user_interfaces/transition_rect/transition_rect.gd").new()
	#preload("res://scenes/user_interfaces/transition_rect/transition_rect.gd").instantiate()
)
var overworld := preload("res://scenes/levels/overworld/SandboxOverworld.tscn")


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	add_child(pause_menu)
	add_child(transition_rect)
	# make sure that the game starts unpaused
	resume()


func _input(event: InputEvent) -> void:
	# if event is InputEventMouseButton:
	# 	# click screen to capture mouse
	# 	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED and not is_paused:
	# 		capture_mouse()

	if event.is_action_pressed("restart"):
		get_tree().change_scene_to_file("res://scenes/levels/overworld/overworld.tscn")

	if event.is_action_pressed("ui_cancel"):
		_toggle_pause()

	if event.is_action_pressed("force_quit"):
		get_tree().quit()


## Reset the progress_state. Returns true if progress_state is not PROGRESS_STATE.GAME_STARTED, false otherwise.
func reset_progress_state() -> bool:
	if progress_state == PROGRESS_STATE.GAME_STARTED:
		return false

	progress_state = PROGRESS_STATE.GAME_STARTED
	return true


## Set the progress_state. It can only be set forward, not backward. Returns true if new_state is after the current state, false otherwise.
func set_progress_state(new_state: int) -> bool:
	if progress_state < new_state:
		progress_state = new_state
		progress_advanced.emit(progress_state)
		return true
	else:
		return false


## Call this function to pause the game
func pause() -> void:
	is_paused = true
	get_tree().paused = true

	pause_menu.show_menu()
	paused.emit()


## Call this function to resume the game
func resume() -> void:
	is_paused = false
	get_tree().paused = false

	pause_menu.hide_menu()
	unpaused.emit()


## Call me lazy, but I prefer to do this
func show_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


## Hate me if you want, but this is easier
func capture_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# TODO: discuss explicit setter use vs using setters on variables and implicit setter use
func _get_player_has_control():
	return player_has_control


func _set_player_has_control(has_control: bool):
	player_has_control = has_control


func _toggle_pause() -> void:
	if is_paused:
		resume()
	else:
		pause()


func tween_cubic_modulate(_self, color: Color = Color.TRANSPARENT, time := 1.0) -> PropertyTweener:
	return create_tween().set_trans(Tween.TRANS_CUBIC).tween_property(
		_self, "modulate", color, time
	)
