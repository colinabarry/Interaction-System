@tool
class_name DialogueSystem extends Control
## A convenience implementation for creating and handling custom dialogues.
##
## [DialogSystem] utilizes [Dialog.Sequence] to abstract away much of the boilerplate required to set up a
## functioning dialogue, including handling the integration of the [Dialog.Sequence] with key [Node]s, as
## listed in the export properties (editor inspector).


## The parent-most node containing your dialogue. This is what will be shown/hidden during/outside-of dialogue.
## [br][br] This node is optional.
@export var dialog_container: NodePath
## The [ItemList] that will display any options in your dialogue.
## [br][br] This node is optional.
@export var dialog_options: NodePath
## The node which will contain the actual text of your dialogue. A normal [Label] is recommended.
## [br][br] This node is [b]MANDATORY[/b].
@export var dialogue: NodePath
## The node which will contain the name of the entity speaking the active dialogue.
## [br][br] This node is optional.
@export var speaker_name: NodePath
## The node which will serve as a "ready-to-continue" indicator after each phrase is displayed (but not when selecting from options).
## [br][br] This node is optional.
@export var next_indicator: NodePath

## Custom export variables to be accessed from the editor inspector.
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
		"type": 24,  # Resource
		"hint": PROPERTY_HINT_RESOURCE_TYPE,
		# "hint_string": "%s/%s:Resource" % [TYPE_OBJECT, TYPE_OBJECT], # Array of Resources
		"usage": _get_usage(),
		"editor_description":
		"The [Resource] files containing a configuration [Dictionary] for the given dialogue. Every config must have the same [code]head[/code]."
	},
	"head":
	{
		"value": "start",
		"type": TYPE_STRING,
		"usage": _get_usage("using_quiz", false),
		"editor_description": "The name of the starting [Dialog] in the provided config."
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
		"value": null,
		"type": TYPE_NODE_PATH,
		"usage": _get_usage("allow_typing", true),
		"editor_description": "A [Timer] which controls the interval for the next character in the dialogue getting displayed."
	},
	"typing_timeout":
	{
		"value": 0.03,
		"type": TYPE_FLOAT,
		"usage": _get_usage("allow_typing", true),
		"editor_description": "How long to wait between displaying each individual character."
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
		"value": null,
		"type": TYPE_NODE_PATH,
		"usage": _get_usage("auto_progress", true),
		"editor_description":
		"A [Timer] which controls the amount of time before going to the next phrase in the [Dialog.Sequence] after the current phrase is fully displayed."
	},
	"progress_timeout":
	{
		"value": 2,
		"type": TYPE_FLOAT,
		"usage": _get_usage("auto_progress", true),
		"editor_description":
		"How long to wait after a phrase is displayed before progressing to the next phrase."
	},
}


# CUSTOM EXPORT HELPERS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

## Retrieve the value of an export_property or null if the property does not exist.
func get_export(property: String) -> Variant:
	if property in export_properties:
		return export_properties[property].value

	return null


## Set the value of an export_property and call [method notify_property_list_changed]
## if the property was changed in the editor inspector, not during runtime.
## [br]Returns a bool representing whether the [code]set[/code] succeeded.
func set_export(property: String, value: Variant) -> bool:
	if property in export_properties:
		export_properties[property].value = value

		if Engine.is_editor_hint():
			notify_property_list_changed()

		return true

	return false


# Get the property usage flag as to whether or not the export variable should
# show inside the editor inspector.
# NOTE: if you include a condition, then you MUST also include a target!
func _get_usage(condition := "", target: Variant = null) -> Callable:
	return (
		(func(): return PROPERTY_USAGE_DEFAULT)
		if condition == ""
		else (func(): return (
			PROPERTY_USAGE_DEFAULT if get_export(condition) == target else PROPERTY_USAGE_NO_EDITOR
		))
	)


# script-wide `get` override
# returning null tells the engine to `get` normally
func _get(property: StringName) -> Variant:
	return get_export(property)


# script-wide `set` override
# returning true tells the engine we set the property ourselves
# returning false tells the engine to `set` normally
func _set(property: StringName, value: Variant) -> bool:
	return set_export(property, value)


# script-wide `property_list` override
# the returned list is appended to the end of the script's `property_list`
# note: these do not have to be exclusively editor inspector variables, but that is how it is being used here
func _get_property_list() -> Array[Dictionary]:
	var property_list: Array[Dictionary] = []

	for property in export_properties:
		var hint = export_properties[property].get("hint")
		var hint_string = export_properties[property].get("hint_string")
		property_list.push_back({
			"name": property,
			"hint": hint if hint else PROPERTY_HINT_NONE,
			"hint_string": hint_string if hint_string else "",
			"type": export_properties[property].type,
			"usage": export_properties[property].usage.call(),
			"editor_description": export_properties[property].editor_description,
		})


	return property_list


#========================================================================================================
# MAIN SCRIPT >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#========================================================================================================

## Is the [Node] assigned to [member dialog_container] currently set to visible?
var is_visible := false
## A [Tween] for animating the [Node] assigned to [member next_indicator] up and down.
var indicator_tweener: Tween

## The [Dialog.Sequence] controlling the current dialogue.
var dialog_sequence: Dialog.Sequence

@onready var _dialog_container := get_node(dialog_container)
@onready var _dialog_options := get_node(dialog_options)
@onready var _dialogue := get_node(dialogue)
@onready var _speaker_name := get_node(speaker_name)
@onready var _next_indicator := get_node(next_indicator)
@onready var _next_char_timer: Timer
@onready var _next_phrase_timer: Timer


func _ready() -> void:
	# don't want it to try to setup a dialogue while you're creating it
	if Engine.is_editor_hint():
		return

	_setup_sequence(get_dialogue_config())
	_setup_speaker_name()
	_setup_dialogue()
	_setup_options()
	_setup_next_indicator()
	_setup_char_timer()
	_setup_phrase_timer()

	_setup_misc_callbacks()

	hide_children()
	clear_children()


# TEMPORARY FOR TESTING
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


# SIGNALS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

func _on_option_clicked(index: int, _at_position, mouse_button_index: MouseButton) -> void:
	if mouse_button_index != MOUSE_BUTTON_LEFT:
		return

	choose_option(index)


func _on_dialogue_clicked(event: InputEvent) -> void:
	if (
		not event is InputEventMouseButton
		or event.button_index != MOUSE_BUTTON_LEFT
		or not event.pressed
	):
		return

	handle_next_phrase()


func _on_next_phrase_timer_timeout() -> void:
	handle_next_phrase()


func _on_next_char_timer_timeout() -> void:
	handle_next_char()


# INTERNAL >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

func _setup_sequence(config: Dictionary) -> void:
	if get_export("using_quiz"):
		dialog_sequence = Quiz.new(config).sequence
	else:
		var temp = Dialog.Sequence.build(config, get_export("head"), {"return_objs": true})
		dialog_sequence = temp.sequence

		for key in temp.dialogs:
			# having a key which includes "options" in your config denotes that the options should
			# be displayed without the dialogue (i.e., the dialog_container will be hidden)
			if "options" in key:
				temp.dialogs[key].on_before_all(func():
					hide_children()
					clear_children()
					show_options()
					)

	dialog_sequence.allow_typing = get_export("allow_typing")


func _setup_next_indicator() -> void:
	if _next_indicator:
		indicator_tweener = create_tween().set_loops()
		indicator_tweener.tween_property(_next_indicator, "position", Vector2(0, -5), 0.5).as_relative()
		indicator_tweener.tween_property(_next_indicator, "position", Vector2(0, 5), 0.5).as_relative()

		dialog_sequence.on_before_each(_next_indicator.hide)


func _setup_char_timer() -> void:
	if get_export("allow_typing"):
		_next_char_timer = get_node(get_export("typing_timer"))
		_next_char_timer.set_wait_time(get_export("typing_timeout"))
		_next_char_timer.timeout.connect(_on_next_char_timer_timeout)
		dialog_sequence.set_char_timer(_next_char_timer)


func _setup_phrase_timer() -> void:
	if get_export("auto_progress"):
		_next_phrase_timer = get_node(get_export("progress_timer"))
		_next_phrase_timer.one_shot = true
		_next_phrase_timer.set_wait_time(get_export("progress_timeout"))
		_next_phrase_timer.timeout.connect(_on_next_phrase_timer_timeout)


func _setup_dialogue() -> void:
	_dialogue.gui_input.connect(_on_dialogue_clicked)


func _setup_options() -> void:
	if _dialog_options:
		_dialog_options.item_clicked.connect(_on_option_clicked)
		dialog_sequence.on_before_options(show_options)
		dialog_sequence.on_after_options(_dialog_options.hide)


func _setup_speaker_name() -> void:
	if _speaker_name:
		dialog_sequence.on_before_all(func(): _speaker_name.text = dialog_sequence.get_speaker())


func _setup_misc_callbacks() -> void:
	(
		dialog_sequence
		. on_after_each(func():
			if _next_indicator:
				try_show_indicator()
			if get_export("auto_progress") and (dialog_sequence.still_talking() or (dialog_sequence.has_next() and not dialog_sequence.has_options())):
				_next_phrase_timer.start()
			)
	)


# DIALOG SYSTEM "API" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

## Retrieve the configuration [Dictionary] at the specified [param idx] of the "config" member
## of the provided dialogue [Resource]. Returns the first element if the key does not exist, or
## the config itself if it is not an Array.
func get_dialogue_config(idx := 0) -> Dictionary:
	var config = get_export("dialogue_resource").config
	return config[idx] if config is Array else config


## Try to start the [Dialog.Sequence] if it hasn't been already.
func try_begin_dialog() -> void:
	if dialog_sequence.cold:
		_dialogue.text = dialog_sequence.begin_dialog()
		print("name: ", dialog_sequence.get_speaker())


func handle_next_char() -> void:
	_dialogue.text += dialog_sequence.next(false)  #> shouldn't_skip_typing


func handle_next_phrase() -> void:
	var active_text = dialog_sequence.next()

	if dialog_sequence.dead:
		hide_children()
		clear_children()
		dialog_sequence.reset()
	else:
		_dialogue.text = active_text


## Choose an option from the current set of options.
func choose_option(idx: int) -> void:
	if not dialog_sequence.ready_for_options():
		return

	_dialog_options.clear()
	if not is_visible:
		show_box()
	_dialogue.text = dialog_sequence.choose_option(idx)


## Change the active [Dialog.Sequence] to a new one.
## [br]Accepts a [Dialog.Sequence], a [Dictionary] denoting a config with the same [code]head[/code] as defined in the
## export properties, or an [int] denoting an index of the [code]dialogue_resource[/code] export property.
func change_sequence(config: Variant) -> void:
	if config is Dialog.Sequence:
		dialog_sequence = config
		return

	match typeof(config):
		TYPE_DICTIONARY: _setup_sequence(config)
		TYPE_INT: _setup_sequence(get_dialogue_config(config))

	_setup_next_indicator()
	_setup_char_timer()
	_setup_options()
	_setup_speaker_name()
	_setup_misc_callbacks()


func try_show_indicator() -> void:
	if not dialog_sequence.ready_for_options():
		_next_indicator.show()


## Clear the contents of the dialogue and the options (if it exists).
func clear_children() -> void:
	if _dialog_options:
		_dialog_options.clear()

	_dialogue.text = ""


## Hide all children of the [DialogSystem].
func hide_children() -> void:
	if _dialog_container:
		_dialog_container.hide()
		is_visible = false
	if _dialog_options:
		_dialog_options.hide()
	if _next_indicator:
		_next_indicator.hide()


## Show the dialog_container and begin the [Dialog.Sequence] if it hasn't been already.
func show_box() -> void:
	if _dialog_container:
		_dialog_container.show()
		is_visible = true

	try_begin_dialog()


## Clear and hide the options for the current [Dialog].
func hide_options() -> void:
	if _dialog_options:
		_dialog_options.hide()
		_dialog_options.clear()


## Populate and display the options for the current [Dialog].
func show_options() -> void:
	if not dialog_sequence.ready_for_options() or _dialog_options.get_item_count() != 0:
		return

	for option_name in dialog_sequence.get_option_names():
		_dialog_options.add_item(option_name)
		_dialog_options.show()
