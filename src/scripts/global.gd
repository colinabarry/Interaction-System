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

#jump minigame vars
var is_in_minigame := false
var correct_input_jumpgame := false
var diff_progression = 0
var minigame_progressed = false
var jump_mini_over = false

var pause_menu: TextureRect = (
	preload("res://scenes/user_interfaces/pause_menu/pause_menu.tscn").instantiate()
)
# var dialog_box: Control = (
# 	preload("res://scenes/user_interfaces/dialog_box/dialog_box.tscn").instantiate()
# )


func _ready() -> void:
	#
	process_mode = Node.PROCESS_MODE_ALWAYS

	# add_child(dialog_box)
	add_child(pause_menu)
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


func get_correct_input_jumpgame():
	return correct_input_jumpgame


func set_correct_input_jumpgame(correct_in: bool):
	correct_input_jumpgame = correct_in


func get_is_in_minigame():
	return is_in_minigame


func set_is_in_minigame(in_mini: bool):
	is_in_minigame = in_mini


# ## Advances the current `progress_state` to the next state.
# ## Returns false if `progress_state` == GAME_COMPLETED, true otherwise.
# func advance_progress_state() -> bool:
# 	if progress_state < GAME_COMPLETED:
# 		progress_state += 1
# 		progress_advanced.emit(progress_state)
# 		return true
# 	return false


## Set the progress_state. It can only be set forward, not backward.
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


func set_jumpmini_over(is_over: bool):
	jump_mini_over = is_over


func get_jumpmini_over():
	return jump_mini_over


func set_jumpmini_global_diff(difficulty: int):
	diff_progression = difficulty
	minigame_progressed = true


func get_jumpmini_global_diff():
	minigame_progressed = false
	return diff_progression


func _toggle_pause() -> void:
	if is_paused:
		resume()
	else:
		pause()
