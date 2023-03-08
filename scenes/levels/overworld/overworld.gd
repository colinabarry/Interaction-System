extends Node

var is_paused := false

@onready var pause_menu: TextureRect = $Blur


func _ready():
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
