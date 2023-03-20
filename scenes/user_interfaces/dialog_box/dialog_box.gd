extends CanvasLayer

var is_visible := false

var dialogs: Dictionary  #<String, Dialog>
var dialog_sequence: Dialog.Sequence

@onready var dialog_container = $DialogContainer
@onready var dialog_options = $DialogContainer/MarginContainer/HBoxContainer/Options
@onready var dialogue = $DialogContainer/MarginContainer/HBoxContainer/Dialogue
@onready var next_char_timer = $NextCharTimer


func _init():
	var temp = Dialog.Sequence.build(Dialogues.test_config, "start", true)
	dialogs = temp.dialogs
	dialog_sequence = temp.sequence

	dialog_sequence.on_before_next(display_options)


func _ready():
	hide_box()


func _input(event: InputEvent):
	if is_visible and event.is_action_pressed("move_jump"):
		handle_next_phrase()


func _on_options_item_clicked(index, _at_position, mouse_button_index):
	if mouse_button_index != MOUSE_BUTTON_LEFT:
		return

	dialog_options.clear()
	dialogue.text = dialog_sequence.choose_option(index)


func _on_dialogue_gui_input(event: InputEvent):
	#<TEMP :debug>
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		dialog_sequence.set_dialog(dialogs.start)
		dialog_options.clear()
	#</TEMP>
	elif (
		not event is InputEventMouseButton
		or event.button_index != MOUSE_BUTTON_LEFT
		or not event.pressed
	):
		return

	handle_next_phrase()


func _on_next_char_timer_timeout():
	dialogue.text += dialog_sequence.next(false)  #> shouldn't_skip_typing


func hide_box():
	dialog_container.hide()
	is_visible = false
	dialogue.text = ""


func show_box():
	dialog_container.show()
	is_visible = true
	dialogue.text = dialog_sequence.begin_dialog(next_char_timer, 0.15)


func display_options():
	print("> display_options:", dialog_sequence.ready_for_options() and dialog_options.get_item_count() == 0)
	if dialog_sequence.ready_for_options() and dialog_options.get_item_count() == 0:
		for option_name in dialog_sequence.get_option_names():
			dialog_options.add_item(option_name)


func handle_next_phrase():
	var active_text = dialog_sequence.next()
	if dialog_sequence.dead:
		hide_box()
	else:
		dialogue.text = active_text
