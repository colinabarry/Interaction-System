extends Node

var is_paused := false
var player_has_control := true
var is_in_minigame := false
var correct_input_jumpgame := false

var pause_menu: TextureRect = (
	preload("res://scenes/user_interfaces/pause_menu/pause_menu.tscn").instantiate()
)
var dialog_box: Control = (
	preload("res://scenes/user_interfaces/dialog_box/dialog_box.tscn").instantiate()
)


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

	add_child(dialog_box)
	add_child(pause_menu)
	resume()


func _input(event: InputEvent) -> void:
	# if event is InputEventMouseButton:
	# 	# click screen to capture mouse
	# 	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

	if event.is_action_pressed("ui_text_submit"):
		dialog_box.show_box()


func get_correct_input_jumpgame():
	return correct_input_jumpgame

func set_correct_input_jumpgame(correct_in: bool):
	correct_input_jumpgame = correct_in

func get_is_in_minigame():
	return is_in_minigame

func set_is_in_minigame(in_mini: bool):
	is_in_minigame = in_mini


func get_player_has_control():
	return player_has_control


func set_player_has_control(has_control: bool):
	player_has_control = has_control


func toggle_pause() -> void:
	if is_paused:
		resume()
	else:
		pause()


func pause() -> void:
	is_paused = true
	get_tree().paused = true

	pause_menu.show_menu()

	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func resume() -> void:
	is_paused = false
	get_tree().paused = false

	pause_menu.hide_menu()

	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

