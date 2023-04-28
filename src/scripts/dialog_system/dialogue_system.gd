@tool
class_name DialogueSystem extends Node
## A convenience implementation for creating and handling custom dialogues.
##
## [DialogSystem] utilizes [Dialog.Sequence] to abstract away much of the boilerplate required to set up a
## functioning dialogue, including handling the integration of the [Dialog.Sequence] with key [Node]s, as
## listed in the export properties (editor inspector).


# ## The parent-most node containing your dialogue. This is what will be shown/hidden during/outside-of dialogue.
# ## [br][br] This node is optional.
# @export var dialog_container: NodePath
# ## The [ItemList] that will display any options in your dialogue.
# ## [br][br] This node is optional.
# @export var dialog_options: NodePath
# ## The node which will contain the actual text of your dialogue. A normal [Label] is recommended.
# ## [br][br] This node is [b]MANDATORY[/b].
# @export var dialogue: NodePath
# ## The node which will contain the name of the entity speaking the active dialogue.
# ## [br][br] This node is optional.
# @export var speaker_name: NodePath
# ## The node which will serve as a "ready-to-continue" indicator after each phrase is displayed (but not when selecting from options).
# ## [br][br] This node is optional.
# @export var next_indicator: NodePath

## Custom export variables to be accessed from the editor inspector.
var export_properties := {
	"dialog_container":
	{
		"value": null,
		"type": TYPE_NODE_PATH,
		"usage": _get_usage(),
		"editor_description": "The parent-most [Node] containing your dialogue. This is what will be shown/hidden during/outside-of dialogue.[br][br]This [Node] is optional."
	},
	"dialog_options":
	{
		"value": null,
		"type": TYPE_NODE_PATH,
		"usage": _get_usage(),
		"editor_description": "The [Node] that will display any options in your dialogue.[br][br]This [Node] is optional."
	},
	"dialogue":
	{
		"value": null,
		"type": TYPE_NODE_PATH,
		"usage": _get_usage(),
		"editor_description": "The [Node] which will contain the actual text of your dialogue. A normal [Label] is recommended.[br][br]This [Node] is [b]MANDATORY[/b]."
	},
	"speaker_name":
	{
		"value": null,
		"type": TYPE_NODE_PATH,
		"usage": _get_usage(),
		"editor_description": "The [Node] which will contain the name of the entity speaking the active dialogue.[br][br]This [Node] is optional."
	},
	"next_indicator":
	{
		"value": null,
		"type": TYPE_NODE_PATH,
		"usage": _get_usage(),
		"editor_description": "The [Node] which will serve as a \"ready-to-continue\" indicator after each phrase is displayed (but not when selecting from options).[br][br]This [Node] is optional."
	},
	"next_indicator_container":
	{
		"value": null,
		"type": TYPE_NODE_PATH,
		"usage": _get_usage(),
		"editor_description": "The [Node] which will contain the next indicator as well as any other nodes which should be hidden/shown with the next indicator. [br][br]This [Node] is optional."
	},
	"counter":
	{
		"value": null,
		"type": TYPE_NODE_PATH,
		"usage": _get_usage(),
		"editor_description": "A [Label] representing a counter for what [Dialog] you are on out of the current [Dialog.Sequence]. [br][br]This [Node] is optional."
	},
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
	"tween_visibility": {
		"value": false,
		"type": TYPE_BOOL,
		"usage": _get_usage("allow_typing", true),
		"editor_description": "Do you want to have the typing effect be done by tweening character visibility instead?"
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
	var did_set := set_export(property, value)

	var signal_name := "%s_changed" % property
	print("signal_name: %s" % signal_name)
	if signal_name in self:  # guard against export setting before _init runs
		emit_signal(signal_name, value)

	return did_set


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
var text_visibility_tweener: Tween

var options_font_size: int
var options_length: int
var options_idx: int

var dialogs: Dictionary
## The [Dialog.Sequence] controlling the current dialogue.
var dialog_sequence: Dialog.Sequence:
	set(value):
		dialog_sequence = value

		if get_export("counter") != null:
			options_length = 0
			options_idx = 0
			var curr_dialog = dialog_sequence.head
			while curr_dialog.has_next():
				if curr_dialog.has_options():
					options_length += 1
				curr_dialog = curr_dialog.next_dialogs[0]

			dialog_sequence.connect("before_options", func():
				options_idx += 1
				if _counter:
					_counter.text = "%s/%s" % [options_idx, options_length]
				)

		emit_signal("dialog_sequence_changed")


@onready var _dialog_container: Node
@onready var _dialog_options: Node
@onready var _dialogue: Node
@onready var _speaker_name: Node
@onready var _next_indicator: Node
@onready var _next_indicator_container: Node
@onready var _counter: Node
@onready var _next_char_timer: Timer
@onready var _next_phrase_timer: Timer


func _init() -> void:
	for property in get_property_list():
		if property.name.begins_with("_"):  # "private"
			continue

		var signal_name = "%s_changed" % property.name
		var listener_name = "_on_%s" % signal_name

		if not signal_name in self:
			add_user_signal(signal_name, [{
				"name": "value",
				"type": property.type,
			}])

		if listener_name in self:
			print("Connecting %s to %s" % [signal_name, listener_name])
			connect(signal_name, self[listener_name])


func _ready() -> void:
	# don't want it to try to setup a dialogue while you're creating it
	if Engine.is_editor_hint():
		return

	_setup_sequence(get_dialogue_config())
	_setup_nodes()

	hide_children()
	clear_children()


# TEMPORARY FOR TESTING
func _input(event: InputEvent) -> void:
	if is_visible and event.is_pressed() and event.as_text() == "Space":
		handle_next_phrase()

	if event.is_pressed():
		match event.as_text():
			"BracketLeft":
				show_box()
				try_begin_dialogue()

			_:
				var temp = int(event.as_text())
				if temp > 0 and temp < 6:
					choose_option(temp - 1)


# EXPORT PROPERTY SIGNALS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

func _on_dialog_container_changed() -> void:
	_setup_box()

func _on_options_changed() -> void:
	_setup_options()

func _on_dialogue_changed() -> void:
	_setup_dialogue()

func _on_speaker_name_changed() -> void:
	_setup_speaker_name()

func _on_next_indicator_changed() -> void:
	_setup_next_indicator()

func _on_counter_changed() -> void:
	_setup_counter()

func _on_next_char_timer_changed() -> void:
	_setup_char_timer()

func _on_next_phrase_timer_changed() -> void:
	_setup_phrase_timer()

func _on_dialogue_resource_changed() -> void:
	_setup_sequence(get_dialogue_config())


# NODE SIGNALS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

func _on_option_clicked(index: int, _at_position, mouse_button_index: MouseButton) -> void:
	if mouse_button_index != MOUSE_BUTTON_LEFT:
		return

	choose_option(index)


func _on_option_button_clicked(index: int) -> void:
	print("hello there")
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


# DIALOG SIGNALS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

func _on_before_all_options_only() -> void:
	hide_children()
	clear_children()
	show_options()


# SEQUENCE SIGNALS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

func _on_dialog_sequence_changed() -> void:
	dialog_sequence.allow_typing = get_export("allow_typing") and not get_export("tween_visibility")

	_setup_char_timer()  # dependent on the current Sequence
	_setup_speaker_name()  # dependent on the current Sequence
	_setup_counter()  # dependent on the current Sequence

	for listener in get_method_list():
		if listener.name.begins_with("_on_seq_"):
			dialog_sequence.connect(listener.name.right(-8), self[listener.name])

## Runs before the active phrase of [member Dialog.phrases] is updated.
func _on_seq_before_each() -> void:
	if _next_indicator:
		_next_indicator.hide()
		_next_indicator_container.get_node("Space").hide()

## Runs after the active phrase of [member Dialog.phrases] is updated, but before the text is set to the dialogue.
func _on_seq_after_each() -> void:
	if _next_indicator and not dialog_sequence.ready_for_options() and not get_export("tween_visibility"):
		_next_indicator.show()
		_next_indicator_container.get_node("Space").show()

	if get_export("auto_progress") and (dialog_sequence.still_talking() or (dialog_sequence.has_next() and not dialog_sequence.has_options())):
		_next_phrase_timer.start()

## Runs when a [Dialog] is set in a [Dialog.Sequence].
func _on_seq_before_all() -> void:
	_setup_nodes()

## Runs after the last phrase in [member Dialog.phrases] is updated and the full text is displayed.
func _on_seq_after_all() -> void:
	pass

## Runs before the [Dialog.Sequence] sets the next [Dialog].
## [br]You must have at least one element in [member Dialog.next_dialogs] for this to run.
func _on_seq_before_next() -> void:
	pass

## Runs after the [Dialog.Sequence] sets the next [Dialog].
## [br]You must have at least one element in [member Dialog.next_dialogs] for this to run.
func _on_seq_after_next() -> void:
	pass

## Runs when the set of options are ready to be displayed.
## [br]You must have at least two elements in [member Dialog.next_dialogs] for this to run.
func _on_seq_before_options() -> void:
	show_options()

## Runs after an option has been selected and the [Dialog.Sequence] sets the new [Dialog].
## You must have at least two elements in [member Dialog.next_dialogs] for this to run.
func _on_seq_after_options() -> void:
	_dialog_options.hide()

## Runs when the [Dialog.Sequence] is started for the first time ever.
func _on_seq_dirty() -> void:
	pass

## Runs when the [Dialog.Sequence] is reset.
func _on_seq_cold() -> void:
	pass

## Runs when the [Dialog.Sequence] is started.
func _on_seq_hot() -> void:
	pass

## Runs when the [Dialog.Sequence] reaches a dead end.
func _on_seq_dead() -> void:
	hide_children()
	clear_children()

## Runs when the [Dialog.Sequence] is revived.
func _on_seq_revived() -> void:
	pass


# INTERNAL >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

func _setup_sequence(config: Dictionary) -> void:
	if get_export("using_quiz"):
		var temp = Quiz.new(config)
		dialog_sequence = temp.sequence
		dialogs = temp.dialogs
	else:
		var temp = Dialog.Sequence.build(config, get_export("head"), {"return_objs": true})
		dialog_sequence = temp.sequence
		dialogs = temp.dialogs

		for key in temp.dialogs:
			# having a key which includes "options" in your config denotes that the options should
			# be displayed without the dialogue (i.e., the dialog_container will be hidden)
			if "options" in key:
				temp.dialogs[key].connect("before_all", _on_before_all_options_only)


func _try_setup_export_node(node_name: String, export_name: String = "") -> bool:
	var node_path = get_export(export_name if export_name != "" else node_name)
	if node_path == null or node_path.is_empty():
		return false

	var node := get_node(node_path)
	if not node:
		return false

	self["_" + node_name] = node
	return true


func _setup_box() -> void:
	if not _try_setup_export_node("dialog_container"):
		return



func _setup_options() -> void:
	if not _try_setup_export_node("dialog_options"):
		return


func _setup_dialogue() -> void:
	assert(_try_setup_export_node("dialogue"), "You must set the 'dialogue' export variable to the path of the Label node you want to use for displaying the dialogue.")

	_dialogue.gui_input.connect(_on_dialogue_clicked)

	if get_export("tween_visibility"):
		_dialogue.visible_characters_behavior = TextServer.VC_CHARS_AFTER_SHAPING


func _setup_speaker_name() -> void:
	if not _try_setup_export_node("speaker_name"):
		return

	dialog_sequence.connect("before_all", func(): _speaker_name.text = dialog_sequence.get_speaker())


func _setup_next_indicator() -> void:
	if not _try_setup_export_node("next_indicator") or not _try_setup_export_node("next_indicator_container"):
		return

	if indicator_tweener:
		return

	indicator_tweener = create_tween().set_loops()
	indicator_tweener.tween_property(_next_indicator, "position", Vector2(0, -5), 0.5).as_relative()
	indicator_tweener.tween_property(_next_indicator, "position", Vector2(0, 5), 0.5).as_relative()


func _setup_counter() -> void:
	if not _try_setup_export_node("counter"):
		return

	_counter.text = ""


func _setup_char_timer() -> void:
	if get_export("tween_visibility") or not get_export("allow_typing"):
		return

	if not _try_setup_export_node("next_char_timer", "typing_timer"): #"You must set the 'typing_timer' export variable to the path of the Timer node you want to use for typing.")
		return

	_next_char_timer.set_wait_time(get_export("typing_timeout"))
	_next_char_timer.timeout.connect(_on_next_char_timer_timeout)
	dialog_sequence.set_char_timer(_next_char_timer)


func _setup_phrase_timer() -> void:
	if not get_export("auto_progress"):
		return

	assert(_try_setup_export_node("next_phrase_timer", "progress_timer"), "You must set the 'progress_timer' export variable to the path of the Timer node you want to use for auto-progressing.")

	_next_phrase_timer.one_shot = true
	_next_phrase_timer.set_wait_time(get_export("progress_timeout"))
	_next_phrase_timer.timeout.connect(_on_next_phrase_timer_timeout)


func _setup_nodes() -> void:
	_setup_box()
	_setup_options()
	_setup_dialogue()
	_setup_speaker_name()
	_setup_next_indicator()
	_setup_counter()
	_setup_char_timer()
	_setup_phrase_timer()


# DIALOG SYSTEM "API" >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

## Retrieve the configuration [Dictionary] at the specified [param idx] of the "config" member
## of the provided dialogue [Resource]. Returns the first element if the key does not exist, or
## the config itself if it is not an Array.
func get_dialogue_config(idx := 0) -> Dictionary:
	var config = get_export("dialogue_resource").config
	return config[idx] if config is Array else config


## Try to start the [Dialog.Sequence] if it hasn't been already.
func try_begin_dialogue() -> void:
	if not dialog_sequence.cold:
		return

	_dialogue.text = dialog_sequence.begin_dialog()
	_try_tween_dialogue_visibility()


func handle_next_char() -> void:
	_dialogue.text += dialog_sequence.next(false)  #> shouldn't_skip_typing


func handle_next_phrase() -> void:
	if get_export("tween_visibility") and text_visibility_tweener and text_visibility_tweener.is_running():
		text_visibility_tweener.stop()
		_dialogue.visible_characters = -1
		text_visibility_tweener.emit_signal("finished")
		return

	var active_text = dialog_sequence.next()

	if dialog_sequence.dead:
		return

	_dialogue.text = active_text

	_try_tween_dialogue_visibility()


## Choose an option from the current set of options.
func choose_option(idx: int) -> void:
	if not _dialog_options or not dialog_sequence.ready_for_options():
		return

	clear_options()

	if not is_visible:
		show_box()

	_dialogue.text = dialog_sequence.choose_option(idx)
	_try_tween_dialogue_visibility()


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


func toggle_box_theme(value: bool) -> void:
	if not _dialog_container:
		return

	var panel = _dialog_container.get_node("Panel")
	var stylebox = panel.get_theme_stylebox("panel")
	stylebox.corner_radius_top_left = 0 if value else 20
	stylebox.corner_radius_top_right = 0 if value else 20

## Clear the contents of the dialogue and the options (if it exists).
func clear_children() -> void:
	if _dialog_options:
		clear_options()
	if _speaker_name:
		_speaker_name.text = ""

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
		_next_indicator_container.get_node("Space").hide()


## Show the dialog_container.
func show_box() -> void:
	if not _dialog_container:
		return

	toggle_box_theme(false)
	_dialog_container.show()
	is_visible = true


## Clear the options for the current [Dialog].
func clear_options() -> void:
	if not _dialog_options:
		return

	for child in _dialog_options.get_children():
		child.queue_free()

	toggle_box_theme(false)


## Clear and hide the options for the current [Dialog].
func hide_options() -> void:
	if not _dialog_options:
		return

	_dialog_options.hide()
	clear_options()

	toggle_box_theme(false)


## Populate and display the options for the current [Dialog].
func show_options() -> void:
	if not dialog_sequence.ready_for_options() or _dialog_options.get_child_count() != 0:
		return

	var idx = 0
	var using_quiz = get_export("using_quiz")
	for option_name in dialog_sequence.get_option_names():
		var temp_btn = load("res://scenes/user_interfaces/option_button.tscn").instantiate()
		temp_btn.text = "%s. %s " % [idx + 1, option_name] if using_quiz else (option_name + " ")
		temp_btn.connect("pressed", func(): _on_option_button_clicked(idx))
		if options_font_size:
			temp_btn.add_theme_constant_override("font_size", options_font_size)

		_dialog_options.add_child(temp_btn)
		idx += 1

	toggle_box_theme(true)
	_dialog_options.show()


func _try_tween_dialogue_visibility():
	if get_export("tween_visibility"):
		var tween_time: float = _dialogue.text.length() * get_export("typing_timeout")
		_dialogue.visible_ratio = 0
		print("tween_time: %s" % tween_time)
		text_visibility_tweener = create_tween()
		text_visibility_tweener.tween_property(_dialogue, "visible_ratio", 1.0, tween_time)
		text_visibility_tweener.finished.connect(func():
			if _next_indicator and not dialog_sequence.ready_for_options():
				_next_indicator.show()
				_next_indicator_container.get_node("Space").show()
			)




func __new_line_brackets_and_parens_is_super_not_aesthetic():
	var _so_this_is_to_break_the_formatter_for_this_file := "😎"
