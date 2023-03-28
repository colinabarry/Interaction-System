@tool
extends Control


@export var dialog_container: NodePath
@export var dialog_options: NodePath
@export var dialogue: NodePath
@export var speaker_name: NodePath
@export var next_indicator: NodePath


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
	},
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
var indicator_tweener: Tween

var dialog_sequence: Dialog.Sequence


@onready var _dialog_container := get_node(dialog_container)
@onready var _dialog_options := get_node(dialog_options)
@onready var _dialogue := get_node(dialogue)
@onready var _speaker_name := get_node(speaker_name)
@onready var _next_indicator := get_node(next_indicator)
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

	if _next_indicator:
		indicator_tweener = create_tween().set_loops()
		indicator_tweener.tween_property(_next_indicator, "position", Vector2(0, -5), 0.5).as_relative()
		indicator_tweener.tween_property(_next_indicator, "position", Vector2(0, 5), 0.5).as_relative()
		dialog_sequence.on_before_each(_next_indicator.hide)

	next_phrase_timer.one_shot = true
	next_phrase_timer.wait_time = __get("progress_timer")

	(
		dialog_sequence
		. on_after_each(func():
			if _next_indicator:
				try_show_indicator()
			if __get("auto_progress") and (dialog_sequence.still_talking() or (dialog_sequence.has_next() and not dialog_sequence.has_options())):
				next_phrase_timer.start()
			)
	)

	_dialogue.connect("_on_dialogue_gui_input", _on_dialogue_gui_input)

	if _dialog_options:
		_dialog_options.connect("_on_options_item_clicked", _on_options_item_clicked)
		dialog_sequence.on_before_options(show_options)
		dialog_sequence.on_after_options(_dialog_options.hide)

	if _speaker_name:
		dialog_sequence.on_before_all(func(): _speaker_name.text = dialog_sequence.get_speaker())

	hide_box()


func _input(event: InputEvent) -> void:
	if is_visible and event.is_pressed() and event.as_text() == "BracketRight":
		handle_next_phrase()

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
	_dialogue.text += dialog_sequence.next(false)  #> shouldn't_skip_typing


func hide_box():
	_dialog_container.hide()
	if _dialog_options:
		_dialog_options.hide()
	if _next_indicator:
		_next_indicator.hide()

	is_visible = false
	_dialogue.text = ""


func show_box():
	_dialog_container.show()
	is_visible = true

	if dialog_sequence.cold:
		next_char_timer.set_wait_time(__get("typing_timer"))
		dialog_sequence.set_char_timer(next_char_timer)

		_dialogue.text = dialog_sequence.begin_dialog()


func show_options():
	if dialog_sequence.ready_for_options() and _dialog_options.get_item_count() == 0:
		for option_name in dialog_sequence.get_option_names():
			_dialog_options.add_item(option_name)

			_dialog_options.show()


func choose_option(idx: int):
	_dialog_options.clear()
	if not is_visible:
		show_box()
	_dialogue.text = dialog_sequence.choose_option(idx)


func try_show_indicator():
	if not dialog_sequence.ready_for_options():
		_next_indicator.show()


func handle_next_phrase():
	var active_text = dialog_sequence.next()

	if dialog_sequence.dead:
		hide_box()
		dialog_sequence.reset()
	else:
		_dialogue.text = active_text
