extends DialogueLifecycleEvents
class_name Dialog

var speaker := ""
var option_name := ""
var phrase_idx := -1
var char_idx := -1
var phrases := []  #<String>
var next_dialogs := []  #<Dialog>
var using_typing := false  # this will be passed to proceeding Dialogs


func _init(base = [], option = "") -> void:
	phrases = base
	option_name = option


var first_call = true


## Run the after_each and attempt to run the after_all lifecycle events
func after():
	after_each()

	if not still_talking():
		after_all()

		if has_options():
			before_next_dialog()


## Attempt to run the after_each and after_all lifecycle events (w/ a silly caveat)
func after_skip():
	# weird stuff (read: bad design) means this block must be entered
	# at the very start of the sequence, but obviously we don't want
	# to run "after_xxx" lifecycles before anything's happened
	if not first_call:
		print("> skip_typing")
		after()
	else:
		first_call = false


func next(skip_typing := false) -> String:
	if using_typing and still_typing():
		if skip_typing:
			stop_typing()
			after_skip()
			return get_active_phrase()
		return next_char()
	else:
		reset_typing()

	reset_each()
	return next_phrase()


# BOOL STUFF (DIALOG STATE)


## Does this Dialog object have at least one Dialog object proceeding it?
func has_next() -> bool:
	return next_dialogs.size() > 0


## Does this Dialog object have at least two Dialog objects proceeding it?
## (i.e., will the next Dialog need to be selected?)
func has_options() -> bool:
	return next_dialogs.size() > 1


## Does the speaker still have more phrases to display?
func still_talking() -> bool:
	return phrase_idx < phrases.size() - 1


## When using_typing=true, have all characters of the active phrase been displayed?
func still_typing() -> bool:
	return char_idx < len(get_active_phrase()) - 1


# LINKED-LISTY STUFF
# CHANGING INDICES, CONSIDER AS HELPERS


func set_active_phrase(idx: int) -> void:
	phrase_idx = idx % phrases.size()


func set_active_char(idx: int) -> void:
	char_idx = idx % len(get_active_phrase())


func next_phrase() -> String:
	print("> next_phrase")

	if phrase_idx == -1:
		before_all()

	if still_talking():
		set_active_phrase(phrase_idx + 1)

		before_each()
		if not using_typing:
			after()

	return get_active_phrase()


func next_char() -> String:
	if still_typing():
		set_active_char(char_idx + 1)

		if not still_typing():
			print("> next_char")
			after()

	return get_active_char()


## Set the char_idx to the last letter of the active phrase.
func stop_typing() -> void:
	set_active_char(len(get_active_phrase()) - 1)


## Set the phrase_idx to -1 (so that calling next() will return the first phrase)
func reset_talking() -> void:
	set_active_phrase(-1)
	reset_all()


## Set the char_idx to -1 (so that calling next() will return the first character)
func reset_typing() -> void:
	set_active_char(-1)


## Reset the Dialog object's tracked indices to their default values
func reset() -> void:
	reset_talking()
	reset_typing()

	reset_next()  # prolly should be handled by the sequence?


# GETTERS


func get_active_phrase() -> String:
	return phrases[phrase_idx]


func get_active_char() -> String:
	return get_active_phrase()[char_idx]


func get_next_dialog(idx := 0) -> Dialog:
	return next_dialogs[idx]


func get_option_names() -> Array:
	var names = []

	for dialog in next_dialogs:
		names.push_back(dialog.option_name)

	return names


#==========
# BUILDERS
#=========

# PROPERTIES


## Set the names of the speakers for this Dialog object.
## Returns self.
func set_speaker(name: String) -> Dialog:
	speaker = name
	return self


## Set the phrases for this Dialog object.
## Returns self.
func set_base(texts: Array) -> Dialog:
	phrases = texts
	return self


## Set the option name for this Dialog object that will be used when this object is one of many potential next Dialogs.
## Returns self.
func set_option_name(name: String) -> Dialog:
	option_name = name
	return self


## Set the Dialog objects which can come after this Dialog object finishes iterating through its phrases.
## Returns self.
func set_next(dialogs: Array) -> Dialog:
	next_dialogs = dialogs
	return self


## Set whether the Dialog object's phrases should be displayed one character at a time (i.e., recieve 1ch per next() call)
## Returns self.
func set_using_typing(using: bool) -> Dialog:
	using_typing = using
	return self


## Add a dialogue to the end of this Dialog object's list of phrases
## Returns self.
func add_base(text: String) -> Dialog:
	phrases.push_back(text)
	return self


## Add a Dialog object to the end of this Dialog object's list of next Dialogs.
## Returns self.
func add_next(dialog: Dialog) -> Dialog:
	next_dialogs.push_back(dialog)
	return self


# fin building
func build_sequence() -> Sequence:
	return Sequence.new(self)


## FOR THE FUTURE!!
# - reset the sequence?
# - give Sequence master control for allowing_typing?


class Sequence:
	extends DialogueLifecycleEvents

	var dialog: Dialog = null
	var next_char_timer: Timer
	var cold := true # has this Sequence been started?
	var dead := false # has this Sequence reached a dead end?

	func _init(head: Dialog) -> void:
		set_dialog(head)

	## An alternative option to build a dialog sequence using a JSON-style config.
	static func build(config: Dictionary, head: String, return_objs := false):
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

		var dialog_sequence = dialog_map[head].build_sequence()

		return (
			{"dialogs": dialog_map, "sequence": dialog_sequence} if return_objs else dialog_sequence
		)

	# PROXY FUNCs FOR CURRENT DIALOG

	## Does the current active Dialog object have at least one Dialog object proceeding it?
	func has_next() -> bool:
		return dialog.has_next()

	## Does the current active Dialog object have at least two Dialog objects proceeding it?
	## (i.e., will the next Dialog need to be selected?)
	func has_options() -> bool:
		return dialog.has_options()

	## Does the speaker still have more phrases to display?
	func still_talking() -> bool:
		return dialog.still_talking()

	## When using_typing=true, have all characters of the active phrase been displayed?
	func still_typing() -> bool:
		return dialog.still_typing()

	## Does the current active Dialog object have the property using_typing set to true?
	## i.e., is this Dialog trying to use a typing "animation"
	func using_typing() -> bool:
		return dialog.using_typing

	## Get the option names for any proceeding Dialog objects
	func get_option_names() -> Array:
		return dialog.get_option_names()

	## Get the speaker name for the current Dialog object
	func get_speaker() -> String:
		return dialog.speaker

	# SEQUENCE API

	func ready_for_options() -> bool:
		return not dialog.still_talking() and dialog.has_options()

	func set_dialog(new_dialog: Dialog) -> void:
		var _using_typing = null #dialog.using_typing
		var _speaker = null #dialog.speaker
		if dialog != null:
			_using_typing = dialog.using_typing
			_speaker = dialog.speaker

		# let the Dialog object manage calling the Sequence's lifecycle events
		# except for after_next_dialog as the Sequence will handle that for the Dialog
		dialog = (
			new_dialog
			. on_before_each(func():
				before_each(false)
				new_dialog.before_each()
				)
			. on_after_each(func():
				after_each(false)
				new_dialog.after_each()
				)
			. on_before_all(func():
				before_all(false)
				new_dialog.before_all()
				)
			. on_after_all(func():
				after_all(false)
				new_dialog.after_all()
				)
			. on_before_next(func():
				before_next_dialog(false)
				new_dialog.before_next_dialog()
				)
		)
		dialog.reset()
		_reset()

		if _using_typing:
			dialog.using_typing = _using_typing  # propagate using_typing (only if true tho)
		if dialog.speaker == "":
			dialog.set_speaker(_speaker) # propagate speaker if next_dialog does not have one

		dead = false  # mostly for debug

	func begin_dialog(char_timer: Timer = null, wait_time := 0.15) -> String:
		if char_timer != null:
			char_timer.set_wait_time(wait_time)
			next_char_timer = char_timer
			next()  # set the first phrase as active
			next_char_timer.start()
			return ""
		else:
			return next()  # return the first phrase

	func next(should_skip_typing := true) -> String:
		_reset()

		if dialog.using_typing and dialog.still_typing():
			var _next = dialog.next(should_skip_typing)

			if should_skip_typing or not dialog.still_typing():
				next_char_timer.stop()

			return _next
		# beyond here:=> effectively, still_typing is false

		if dialog.still_talking():
			if dialog.using_typing:
				dialog.next()  # set next phrase as active
				next_char_timer.start()
				return ""  # clear the previous phrase to prep. for typing
			return dialog.next()  # next_phrase
		# beyond here:=> still_typing and still_talking are false

		if not dialog.has_next():  # i.e., no Dialogs next (end of sequence)
			dead = true
			return ""  # to avoid unnecessary Nil errors

		if not dialog.has_options():  # i.e., only one Dialog next (no option)
			return choose_option(0)

		return dialog.get_active_phrase()  # resend curr_phrase (waiting for an option to be selected)

	func choose_option(idx: int) -> String:
		if dialog.using_typing:
			_next_dialog(idx)  # start next Dialog and set first phrase as active
			next_char_timer.start()
			return ""  # clear the previous phrase to prep. for typing
		return _next_dialog(idx)  # no more phrases, so start next Dialog and return the first phrase

	## Sets the Timer to be associated with typing individual characters.
	## Not calling this function when a Dialog in your Sequence has its using_typing property set to 'true' will throw an error!
	func set_typing_timer(timer: Timer) -> void:
		next_char_timer = timer

	# INTERNAL HELPERS

	func _next_dialog(idx := 0) -> String:
		var _had_options = dialog.has_options()
		var _after_next = dialog.after_next_dialog

		set_dialog(dialog.get_next_dialog(idx))

		if _had_options:
			after_next_dialog()
			_after_next.call()

		# sets first phrase of the new Dialog as active
		return next()  # val returned is either the first phrase or the first char

	func _reset():
		reset_each()
		reset_all()
		reset_next()
