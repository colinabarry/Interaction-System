extends Control

var is_visible := false
var next_indicator_init_pos: Vector2
var indicator_tweener: Tween

var dialog_sequence: Dialog.Sequence

@export var dialog_list: Dictionary

@onready var dialog_options = $OptionsContainer/Options
@onready var dialog_container = $DialogContainer
@onready var speaker_name = $DialogContainer/MarginContainer/VBoxContainer/SpeakerName
@onready var dialogue = $DialogContainer/MarginContainer/VBoxContainer/HBoxContainer/Dialogue
@onready
var next_indicator = $DialogContainer/MarginContainer/VBoxContainer/HBoxContainer/NextIndicator
@onready var next_char_timer = $NextCharTimer
@onready var next_phrase_timer = $NextPhraseTimer


func _init():
	var temp = Dialog.Sequence.build(Dialogues.doctor, "start", {"return_objs": true})
	dialog_sequence = temp.sequence
	temp.dialogs.options.on_before_all(func():
		print('yolo swag')
		hide_box()
		show_options()
		)


func _ready():
	next_indicator_init_pos = next_indicator.position
	indicator_tweener = create_tween().set_loops()
	indicator_tweener.tween_property(next_indicator, "position", Vector2(0, -5), 0.5).as_relative()
	indicator_tweener.tween_property(next_indicator, "position", Vector2(0, 5), 0.5).as_relative()

	next_phrase_timer.one_shot = true
	next_phrase_timer.wait_time = 1

	dialog_sequence.on_before_each(next_indicator.hide)
	(
		dialog_sequence
		. on_after_each(func():
			try_show_indicator()
			if dialog_sequence.still_talking() or (dialog_sequence.has_next() and not dialog_sequence.has_options()):
				pass
				# next_phrase_timer.start()
			)
	)
	dialog_sequence.on_before_options(show_options)
	dialog_sequence.on_after_options(dialog_options.hide)
	dialog_sequence.on_before_all(func(): speaker_name.text = dialog_sequence.get_speaker())

	hide_box()


func _input(event: InputEvent):
	# if not is_visible:
	# 	return

	if is_visible and event.is_pressed() and event.as_text() == "BracketRight":
		handle_next_phrase()

	if event.is_action_pressed("test_restart"):
		dialog_sequence.reset()
		dialog_options.clear()
		hide_box()

	if event.is_pressed():
		match event.as_text():
			"BracketLeft":
				show_box()
			_:
				var temp = int(event.as_text())
				if temp > 0 and temp < 6:
					choose_option(temp - 1)


func _on_options_item_clicked(index, _at_position, mouse_button_index):
	if mouse_button_index != MOUSE_BUTTON_LEFT:
		return

	choose_option(index)


func _on_dialogue_gui_input(event: InputEvent):
	if (
		not event is InputEventMouseButton
		or event.button_index != MOUSE_BUTTON_LEFT
		or not event.pressed
	):
		return

	handle_next_phrase()


func _on_next_phrase_timer_timeout():
	handle_next_phrase()


func _on_next_char_timer_timeout():
	dialogue.text += dialog_sequence.next(false)  #> shouldn't_skip_typing


func hide_box():
	dialog_container.hide()
	dialog_options.hide()
	next_indicator.hide()

	is_visible = false
	dialogue.text = ""


func show_box():
	dialog_container.show()
	is_visible = true

	if dialog_sequence.cold:
		next_char_timer.set_wait_time(0.03)
		dialog_sequence.set_char_timer(next_char_timer)

		dialogue.text = dialog_sequence.begin_dialog()


func show_options():
	if dialog_sequence.ready_for_options() and dialog_options.get_item_count() == 0:
		for option_name in dialog_sequence.get_option_names():
			dialog_options.add_item(option_name)

			dialog_options.show()


func choose_option(idx: int):
	dialog_options.clear()
	if not is_visible:
		show_box()
	dialogue.text = dialog_sequence.choose_option(idx)


func try_show_indicator():
	if not dialog_sequence.ready_for_options():
		next_indicator.show()


func handle_next_phrase():
	var active_text = dialog_sequence.next()

	if dialog_sequence.dead:
		hide_box()
		dialog_sequence.reset()
	else:
		dialogue.text = active_text
