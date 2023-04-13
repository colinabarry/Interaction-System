class_name Hint extends Control

@export var hint_time := 0.0
@export var hint_text := "Press 'E' to interact"

@onready var hint := $HintText
@onready var hint_timer := $HintTimer

var _hint_text: String


func _ready() -> void:
	_hint_text = hint_text


func start_hint_timer(time := hint_time, text := hint_text) -> void:
	_hint_text = text

	hint_timer.one_shot = true
	hint_timer.wait_time = time
	hint_timer.start()


func fade_out() -> void:
	var _modulate = hint.modulate
	await Global.tween_cubic_modulate(self).finished

	hint.text = ""
	hint.hide()

	hint.modulate = _modulate


func _on_hint_timer_timeout() -> void:
	hint.text = _hint_text
