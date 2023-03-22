extends Control

var is_visible := false

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

### WHY DO V BE SO HIGH??
### ACCOUNT FOR V WIDTH WHEN HIDDEN SO THE TEXT DOESN'T JUMP WHEN IT SHOWS


func _init():
	dialog_sequence = Dialog.Sequence.build(Dialogues.test_config, "start")


func _ready():
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

	# speaker_name.text = dialog_sequence.get_speaker()

	hide_box()
	dialog_options.hide()
	next_indicator.hide()


func _input(event: InputEvent):
	# if not is_visible:
	# 	return

	if is_visible and event.is_action_pressed("move_jump"):
		handle_next_phrase()

	if event.is_action_pressed("test_restart"):
		dialog_sequence.restart()

func _on_options_item_clicked(index, _at_position, mouse_button_index):
	if mouse_button_index != MOUSE_BUTTON_LEFT:
		return

	dialog_options.clear()
	dialogue.text = dialog_sequence.choose_option(index)


func _on_dialogue_gui_input(event: InputEvent):
	#<TEMP :debug>
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		dialog_sequence.restart()
		dialog_options.clear()
	#</TEMP>
	elif (
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
	next_indicator.hide()
	dialog_container.hide()
	is_visible = false
	dialogue.text = ""


func show_box():
	dialog_container.show()
	is_visible = true

	if dialog_sequence.cold:
		dialogue.text = dialog_sequence.begin_dialog(next_char_timer, 0.035)


func show_options():
	if dialog_sequence.ready_for_options() and dialog_options.get_item_count() == 0:
		for option_name in dialog_sequence.get_option_names():
			dialog_options.add_item(option_name)

			dialog_options.show()


func try_show_indicator():
	if not dialog_sequence.ready_for_options():
		next_indicator.show()
		# DRIFTS UPWARD FFIIIXXX
		var tween := create_tween().set_loops()
		tween.tween_property(next_indicator, "position", Vector2(0, -5), 0.5).as_relative()
		tween.tween_property(next_indicator, "position", Vector2(0, 5), 0.5).as_relative()


func handle_next_phrase():
	var active_text = dialog_sequence.next()

	if dialog_sequence.dead:
		hide_box()
		# IF YOU WANT IT TO RESTART THE SEQUENCE THE NEXT TIME THE PLAYER INTERACTS WITH WHOMEVER
		dialog_sequence.restart()
	else:
		dialogue.text = active_text
