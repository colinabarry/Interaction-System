@tool
extends Control


## Export variables to be accessed from the editor inspector.
var export_properties := {
	"using_quiz":
	{
		"value": false,
		"type": TYPE_BOOL,
		"usage": _get_usage(),
		"editor_description": "Are you using a [Quiz]-based dialogue?"
	},
	"dialogue_resource":
	{
		"value": null,
		"type": 24, # Resource
		"usage": _get_usage(),
		"editor_description": "The resource file containing the configuration [Dictionary] for the given dialogue."
	},
	"head":
	{
		"value": "",
		"type": TYPE_STRING,
		"usage": _get_usage("using_quiz", false),
		"editor_description": "The name of the starting Dialog in the provided config"
	},
	"auto_progress":
	{
		"value": false,
		"type": TYPE_BOOL,
		"usage": _get_usage(),
		"editor_description": "Do you want the dialogue to progress without user input?"
	},
	"progress_timer":
	{
		"value": 2,
		"type": TYPE_FLOAT,
		"usage": _get_usage("auto_progress", true),
		"editor_description":
		"How long to wait after a phrase is displayed before progressing to the next phrase."
	},
	"allow_typing":
	{
		"value": true,
		"type": TYPE_BOOL,
		"usage": _get_usage(),
		"editor_description":
		"Do you want [Dialog]s in the [Dialog.Sequence] to be capable of using a 'typing' animation?"
	},
	"typing_timer":
	{
		"value": 0.03,
		"type": TYPE_FLOAT,
		"usage": _get_usage("allow_typing", true),
		"editor_description": "How long to wait between displaying each individual character."
	}
}


# Retrieve the value of an export_property
func __get(property: String) -> Variant:
	if property in export_properties:
		return export_properties[property].value

	return null


# Get the property usage flag as to whether or not the export variable should
# show inside the editor inspector.
# NOTE: if you include a condition, then you MUST also include a target!
func _get_usage(condition := "", target: Variant = null) -> Callable:
	return (
		(func(): return PROPERTY_USAGE_DEFAULT)
		if condition == ""
		else (func(): return (
			PROPERTY_USAGE_DEFAULT if __get(condition) == target else PROPERTY_USAGE_NO_EDITOR
		))
	)


func _get(property: StringName) -> Variant:
	return __get(property)


func _set(property: StringName, value: Variant) -> bool:
	if property in export_properties:
		print("hello")
		export_properties[property].value = value
		notify_property_list_changed()
		return true

	return false


func _get_property_list() -> Array[Dictionary]:
	var property_list: Array[Dictionary] = []

	for property in export_properties:
		property_list.push_back({
			"name": property,
			"hint": PROPERTY_HINT_NONE,
			"type": export_properties[property].type,
			"usage": export_properties[property].usage.call(),
			"editor_description": export_properties[property].editor_description,
		})

	return property_list

#========================================================================================================
#========================================================================================================


var is_visible := false
var next_indicator_init_pos: Vector2
var indicator_tweener: Tween

var dialog_sequence: Dialog.Sequence

@onready var dialog_options := $OptionsContainer/Options
@onready var dialog_container := $DialogContainer
@onready var speaker_name := $DialogContainer/MarginContainer/VBoxContainer/SpeakerName
@onready var dialogue := $DialogContainer/MarginContainer/VBoxContainer/HBoxContainer/Dialogue
@onready
var next_indicator := $DialogContainer/MarginContainer/VBoxContainer/HBoxContainer/NextIndicator
@onready var next_char_timer := $NextCharTimer
@onready var next_phrase_timer := $NextPhraseTimer


func _ready() -> void:
	if __get("using_quiz"):
		dialog_sequence = Quiz.new(__get("dialogue_resource").config).quiz_sequence
	else:
		var temp = Dialog.Sequence.build(__get("dialogue_resource").config, __get("head"), {"return_objs": true})
		dialog_sequence = temp.sequence

		for key in temp.dialogs:
			if "options" in key:
				temp.dialogs[key].on_before_all(func():
					hide_box()
					show_options()
					)

	dialog_sequence.allow_typing = __get("allow_typing")


	next_indicator_init_pos = next_indicator.position
	indicator_tweener = create_tween().set_loops()
	indicator_tweener.tween_property(next_indicator, "position", Vector2(0, -5), 0.5).as_relative()
	indicator_tweener.tween_property(next_indicator, "position", Vector2(0, 5), 0.5).as_relative()

	next_phrase_timer.one_shot = true
	next_phrase_timer.wait_time = __get("progress_timer")

	dialog_sequence.on_before_each(next_indicator.hide)
	(
		dialog_sequence
		. on_after_each(func():
			try_show_indicator()
			if __get("auto_progress") and (dialog_sequence.still_talking() or (dialog_sequence.has_next() and not dialog_sequence.has_options())):
				next_phrase_timer.start()
			)
	)
	dialog_sequence.on_before_options(show_options)
	dialog_sequence.on_after_options(dialog_options.hide)
	dialog_sequence.on_before_all(func(): speaker_name.text = dialog_sequence.get_speaker())

	hide_box()


func _input(event: InputEvent) -> void:
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
		next_char_timer.set_wait_time(__get("typing_timer"))
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
