class_name Dialog

var speakers := [] #<String>
var option_name := ""
var phrase_idx := -1
var char_idx := -1
var phrases := []  #<String>
var next_dialogs := []  #<Dialog>
var using_typing := false # this will be passed to proceeding Dialogs

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
	phrases = base
	option_name = option

func next(skip_typing := false):
	if using_typing and still_typing():
		if skip_typing:
			stop_typing()
			return get_active_phrase()
		return next_char()

	char_idx = -1
	return next_phrase()


# BOOL STUFF (DIALOG STATE)

## Does this Dialog object have at least one Dialog object proceeding it?
func has_next():
	return next_dialogs.size() > 0

## Does this Dialog object have at least two Dialog objects proceeding it?
## (i.e., will the next Dialog need to be selected?)
func has_options():
	return next_dialogs.size() > 1

## Does the speaker still have more phrases to display?
func still_talking():
	return phrase_idx < phrases.size() - 1

## When using_typing=true, have all characters of the active phrase been displayed?
func still_typing():
	return char_idx < len(get_active_phrase()) - 1

# LINKED-LISTY STUFF
# CHANGING INDICES, CONSIDER AS HELPERS

func set_active_phrase(idx: int):
	phrase_idx = idx % phrases.size()

func set_active_char(idx: int):
	char_idx = idx % len(get_active_phrase())

func next_phrase():
	if phrase_idx != phrases.size() - 1:
		set_active_phrase(phrase_idx + 1)
	return get_active_phrase()

func next_char():
	if char_idx != len(get_active_phrase()) - 1:
		set_active_char(char_idx + 1)
	return get_active_char()

func prev_phrase():
	if phrase_idx != 0:
		set_active_phrase(phrase_idx - 1)
	return get_active_phrase()

# no prev_char
# would force a particular implementation
# if you want it, you can do so without adding anything here

func reset():
	set_active_phrase(-1)
	set_active_char(-1)

## Set the char_idx to the last letter of the active phrase.
func stop_typing():
	char_idx = len(get_active_phrase()) - 1

# GETTERS

func get_active_phrase():
	return phrases[phrase_idx]

func get_active_char():
	return get_active_phrase()[char_idx]

func get_next_dialog(idx := 0):
	return next_dialogs[idx]

func get_option_names():
	var names = []
	for dialog in next_dialogs:
		names.push_back(dialog.option_name)

	return names


#==========
# BUILDERS
#=========

# PROPERTIES

## Set the names of the speakers for this Dialog object.
## Returns self for builder pattern.
func set_speakers(names: Array):
	speakers = names
	return self

## Set the phrases for this Dialog object.
## Returns self for builder pattern.
func set_base(texts: Array):
	phrases = texts
	return self

## Set the option name for this Dialog object that will be used when this object is one of many potential next Dialogs.
## Returns self for builder pattern.
func set_option_name(name: String):
	option_name = name
	return self

## Set the Dialog objects which can come after this Dialog object finishes iterating through its phrases.
## Returns self for builder pattern.
func set_next(dialogs: Array):
	next_dialogs = dialogs
	return self

func set_using_typing(using: bool):
	using_typing = using
	return self

## Add a speaker name to the end of this Dialog object's list of speakers. 
## Returns self for builder pattern.
func add_speaker(name: String):
	speakers.push_back(name);

## Add a dialogue to the end of this Dialog object's list of phrases
## Returns self for builder pattern.
func add_base(text: String):
	phrases.push_back(text)
	return self

## Add a Dialog object to the end of this Dialog object's list of next Dialogs.
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


## FOR TOMORROW!!
# - fix the stupid ass non-clearing issue
# - add callbacks to Sequence
# - figure out where they should be called
# - adjust Sequence funcs to rely on the callbacks where possible
# - have the options display after typing is finished
# - figure out where Dialog callbacks should be called
# - there shouldn't be anything that could even rely on the callbacks ?

## FOR THE FUTURE!!
# - add phrase_timer functionality


class Sequence:
	var dialog: Dialog
	var next_phrase_timer: Timer
	var next_char_timer: Timer
	var dead := false

	func _init(head: Dialog):
		dialog = head;

	## An alternative option to build a dialog sequence using a JSON-style config.
	static func build(config: Dictionary, head: String, return_objs = false):
		var dialog_map = {}
		for name in config:
			var _dialog = Dialog.new()
			for field in config[name]:
				if field == "next":
					continue

				_dialog["set_%s" % field].call(config[name][field])

			dialog_map[name] = _dialog

		for name in dialog_map:
			for next_dialog in config[name].next:
				dialog_map[name].add_next(dialog_map[next_dialog])

		var dialog_sequence = dialog_map[head].build_sequence();

		return {
			"dialogs": dialog_map,
			"sequence": dialog_sequence
		} if return_objs else dialog_sequence

	# PROXY FUNCs FOR CURRENT DIALOG

	func has_next():
		return dialog.has_next()

	func has_options():
		return dialog.has_options()

	func still_talking():
		return dialog.still_talking()

	func still_typing():
		return dialog.still_typing()

	func using_typing():
		return dialog.using_typing

	func get_option_names():
		return dialog.get_option_names()

	# SEQUENCE API

	func ready_for_options():
		return not dialog.still_talking() and dialog.has_options()

	func stop_typing():
		next_char_timer.stop()
		dialog.stop_typing()

	# mostly for debug
	func set_dialog(new_dialog: Dialog):
		dialog = new_dialog
		dialog.reset()
		dead = false

	func next(called_from_tick = false):
		if dialog.using_typing and dialog.still_typing():
			if called_from_tick:
				var next_char = dialog.next()
				if not dialog.still_typing():
					next_char_timer.stop()
				return next_char
			else:
				next_char_timer.stop()
				return dialog.next(true) # skip typing, output full curr_phrase
		# beyond here:=> effectively, both using_typing and still_typing are false

		if dialog.still_talking():
			if dialog.using_typing:
				dialog.next() # set next phrase as active
				next_char_timer.start() # IS THIS CAUSING NEXT TO BE CALLED AND IT'S DOING A SKIP_TYPING THING?????
				print('tf')
				return "" # clear the previous phrase to prep. for typing
			return dialog.next() # next_phrase
		# beyond here:=> still_talking is false

		if not dialog.has_next(): # i.e., no Dialogs next (end of sequence)
			dead = true
			return "" # to avoid unnecessary Nil errors

		if not dialog.has_options(): # i.e., only one Dialog next (no option)
			return choose_option(0)

		return dialog.get_active_phrase() # resend curr_phrase (waiting for an option to be selected)

	func choose_option(idx: int):
		if dialog.using_typing:
			_next_dialog(idx) # start next Dialog
			next_char_timer.start()
			return "" # clear the previous phrase to prep. for typing
		return _next_dialog(idx) # no more phrases, so start next Dialog and return the first phrase

	## Sets the Timer to be associated with typing individual characters.
	## Not calling this function when a Dialog in your Sequence has its using_typing property set to 'true' will throw an error!
	func set_typing_timer(timer: Timer):
		next_char_timer = timer

	# INTERNAL HELPERS

	func _next_dialog(idx := 0):
		var using = dialog.using_typing
		dialog = dialog.get_next_dialog(idx)
		dialog.reset()
		if using:
			dialog.using_typing = using # propagate using_typing (only if true tho)

		# sets first phrase of the new Dialog as active
		return next() # val returned is either the first phrase or the first char
