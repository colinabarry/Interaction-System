extends Control

@export var hint_time := 3.0
@export var hint_text := "Press 'E' to interact"

@onready var hint := $HintText
@onready var hint_timer := $HintTimer

var _hint_text: String

var tween_time := 1


func _ready() -> void:
	_hint_text = hint_text


func start_hint_timer(time := hint_time, text := hint_text) -> void:
	_hint_text = text

	hint_timer.one_shot = true
	hint_timer.wait_time = time
	hint_timer.start()


func fade_out() -> void:
	var _modulate = hint.modulate
	await tween_cubic_modulate(Color.TRANSPARENT, tween_time).finished

	hint.text = ""
	hint.hide()

	hint.modulate = _modulate


func _on_hint_timer_timeout() -> void:
	hint.text = _hint_text


func tween_cubic_modulate(color: Color, time: int) -> PropertyTweener:
	return create_tween().set_trans(Tween.TRANS_CUBIC).tween_property(self, "modulate", color, time)
