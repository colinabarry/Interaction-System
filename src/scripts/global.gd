extends Node

var is_paused := false

var pause_menu: TextureRect = (
	preload("res://scenes/user_interfaces/pause_menu/pause_menu.tscn").instantiate()
)


func _ready() -> void:
	add_child(pause_menu)
	var fstring = "%s is a string, %d is an int" % ["hello", 4]
	print(fstring)
	# pause()


func _input(event: InputEvent) -> void:
	# if event is InputEventMouseButton:
	# 	# click screen to capture mouse
	# 	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	if event.is_action_pressed("ui_cancel"):
		toggle_pause()


func toggle_pause() -> void:
	if is_paused:
		resume()
	else:
		pause()


func pause() -> void:
	is_paused = true

	pause_menu.show_menu()

	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func resume() -> void:
	is_paused = false

	pause_menu.hide_menu()

	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
