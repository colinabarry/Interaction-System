class_name Dialog

var option_name := ""
var active_idx := -1
var dialogues := []  #<String>
var next_dialogs := []  #<Dialog>

var _before_each := func():
	return
var _after_each := func():
	return
var _before_all := func():
	return
var _after_all := func():
	return
var _before_next_dialog := func():
	return
var _after_next_dialog := func():
	return

## Runs before active_text is updated
var before_each := func():
	_before_each.call()
## Runs after active_text is updated and after the full text is written to the scene
var after_each := func():
	_after_each.call()
## Runs when this Dialog object is selected or when active_text is set to 0
var before_all := func():
	_before_all.call()
## Runs after the last _base_texts element is written to the scene
var after_all := func():
	_after_all.call()
## Runs before set of next_dialog options are displayed on the screen.
## You must have at least two elements in _next_dialogs for this to run.
var before_next_dialog := func():
	if next_dialogs.size() < 2: 
		return
	_before_next_dialog.call()
## Runs after the next_dialog option has been selected
## You must have at least two elements in _next_dialogs for this to run.
var after_next_dialog := func():
	if next_dialogs.size() < 2: 
		return
	_after_next_dialog.call()


func _init(base = [], option = ""):
	dialogues = base
	option_name = option

# BOOL STUFF

func has_options():
	return not (next_dialogs.size() < 2)

func has_next():
	return next_dialogs.size() > 0

func still_talking():
	return active_idx < dialogues.size() - 1

# LISTY STUFF

func set_active(idx: int):
	active_idx = idx % dialogues.size()

func next():
	if active_idx == dialogues.size():
		return
	set_active(active_idx + 1)

func prev():
	if active_idx == 0:
		return
	set_active(active_idx - 1)

func reset():
	set_active(-1)

# GETTERS

func get_active():
	return dialogues[active_idx]

func get_next_dialog(idx: int):
	return next_dialogs[idx]

func get_next_as_strs():
	var names = []
	for dialog in next_dialogs:
		names.push_back(dialog.option_name)

	return names


#==========
# BUILDERS
#=========

# PROPERTIES

## Set the dialogues for this Dialog object.
## Returns self for builder pattern.
func set_base(texts: Array):
	dialogues = texts
	return self

## Set the option name for this Dialog object that will be used when this object is one of many potential next Dialogs.
## Returns self for builder pattern.
func set_opt_name(name: String):
	option_name = name
	return self

## Set the Dialog objects which can come after this Dialog object finishes iterating through its dialogues.
## Returns self for builder pattern.
func set_next(dialogs: Array):
	next_dialogs = dialogs
	return self

## Add a dialogue to the end of this Dialog object's list of dialogues
## Returns self for builder pattern.
func add_base(text: String):
	dialogues.push_back(text)
	return self

## Add a Dialog object to the end of this Dialog object's list of next Dialogs
## Returns self for builder pattern.
func add_next(dialog: Dialog):
	next_dialogs.push_back(dialog)
	return self

# "events"
func on_before_each(fn):
	_before_each = fn
	return self

func on_after_each(fn):
	_after_each = fn
	return self

func on_before_all(fn):
	_before_all = fn
	return self

func on_after_all(fn):
	_after_all = fn
	return self

func on_before_next(fn):
	_before_next_dialog = fn
	return self

func on_after_next(fn):
	_after_next_dialog = fn
	return self

# fin building
func build_sequence():
	return Sequence.new(self)

class Sequence:
	var dialog: Dialog
	var still_talking = true
	var dead = false

	func _init(head: Dialog):
		dialog = head;

	## An alternative option to build a dialog sequence using a JSON-style config.
	static func build(config: Dictionary, head: String, return_objs = false):
		var dialog_map = {}
		for name in config:
			print("name: ", name)
			dialog_map[name] = Dialog.new(config[name].base, config[name].option_name)

		for name in dialog_map:
			for next_dialog in config[name].next:
				dialog_map[name].add_next(dialog_map[next_dialog])

		var dialog_sequence = dialog_map[head].build_sequence();

		return {
			"dialogs": dialog_map,
			"sequence": dialog_sequence
		} if return_objs else dialog_sequence

	func has_options():
		return dialog.has_options()

	func get_option_names():
		return dialog.get_next_as_strs()

	func set_dialog(new_dialog: Dialog):
		dialog = new_dialog
		dialog.reset()
		dead = false

	func next(idx = -1):
		if idx != -1:
			dialog = dialog.get_next_dialog(idx)
			dialog.reset()
			return next()

		if dialog.active_idx == -1:
			dialog.before_all.call()
			still_talking = true

		if still_talking:
			dialog.before_each.call()
			dialog.next()
			still_talking = dialog.still_talking()
			return dialog.get_active()

		if not dialog.has_next():
			dead = true
			return ''

		if not dialog.has_options():
			dialog = dialog.get_next_dialog(0)
			dialog.reset()
			return next()
