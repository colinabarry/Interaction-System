class_name Dialog extends DialogueLifecycleEvents
## Creates a node to store dialogue for a given entity.
##
## [Dialog] is a node intended to be used in a [Dialog.Sequence], not alone, to manage
## dialogue-based interactions. So long as the [member phrases] property is populated,
## the [Dialog] should function as expected. If [member speaker] or [member using_typing]
## are not set and this [Dialog] was preceeded by another [Dialog] in a [Dialog.Sequence],
## then those properties will propagate to this one.
## You may optionally define lifecycle events.
## [br]See: [DialogueLifecycleEvents]


## The name which denotes the entity "speaking" for this [Dialog].
var speaker := ""
## The name that will be used in an [ItemList] when this [Dialog] is in the [member next_dialogs] of another Dialog that [method has_options].
var option_name := ""
## The index of the active phrase of [member phrases].
var phrase_idx := -1
## The index of the active character of the active phrase of [member phrases].
var char_idx := -1
## The dialogues to be displayed. Each element represents one pane.
var phrases := [] #[String]
## The [Dialog]s which can come after this Dialog finishes iterating through its [member phrases].
var next_dialogs := [] #[Dialog]
## Should [member phrases] be displayed one character at a time (i.e., recieve 1ch per [method next] call)?
var using_typing := false  # this will be passed to proceeding Dialogs


func _init(base = [], option = "") -> void:
	phrases = base
	option_name = option


## Run the after_each and attempt to run the after_all, before_next_dialog, and before_options lifecycle events.
## [br]See: [DialogueLifecycleEvents]
func after():
	after_each()

	if not still_talking():
		after_all()

		if has_next():
			before_next_dialog()
		if has_options():
			before_options()


var _first_call = true
# Attempt to run the after_each and after_all lifecycle events (w/ a silly caveat).
func _after_skip():
	# weird stuff (read: bad design) means this block must be entered
	# at the very start of the sequence, but obviously we don't want
	# to run "after_xxx" lifecycles before anything's happened
	if not _first_call:
		print("> skip_typing")
		after()
	else:
		_first_call = false


## Retrive the next character or phrase, or the full active phrase if [param skip_typing] is [b]true[/b].
func next(skip_typing := false) -> String:
	if using_typing and still_typing():
		if skip_typing:
			stop_typing()
			_after_skip()

			return get_active_phrase()
		return _next_char()

	reset_typing()
	return _next_phrase()


# BOOL STUFF (DIALOG STATE) >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

## Is there at least one [Dialog] in [member next_dialogs]?
func has_next() -> bool:
	return next_dialogs.size() > 0


## Are there at least two [Dialog]s in [member next_dialogs]?
## [br](i.e., will the next Dialog need to be selected?)
func has_options() -> bool:
	return next_dialogs.size() > 1


## Does the [member speaker] still have more [member phrases] to display?
func still_talking() -> bool:
	return phrase_idx < phrases.size() - 1


## When [member using_typing] is [b]true[/b], have all characters of the active phrase been displayed?
func still_typing() -> bool:
	print("still_typing: ", phrase_idx)
	return phrase_idx > -1 and char_idx < len(get_active_phrase()) - 1


# LINKED-LISTY STUFF >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# CHANGING INDICES, CONSIDER AS HELPERS

## Set [member phrase_idx].
## [br][br]NOTE: This function applies a modulo to the provided idx using the length of [member phrases].
func set_active_phrase(idx: int) -> void:
	phrase_idx = idx % phrases.size()


## Set [member char_idx].
## [br][br]NOTE: This function applies a modulo to the provided idx using the length of the active phrase.
func set_active_char(idx: int) -> void:
	char_idx = idx % len(get_active_phrase())


# Retrieves the next phrase in [member phrases], or the current phrase if still_talking() is false,
# and calls any lifecycle events as appropriate.
func _next_phrase() -> String:
	print("> next_phrase")
	reset_each()

	if still_talking():
		set_active_phrase(phrase_idx + 1)

		before_each()
		if not using_typing:
			after()

	return get_active_phrase()


# Retrieves the next character of the active phrase and calls any lifecycle events as appropriate.
func _next_char() -> String:
	if still_typing():
		set_active_char(char_idx + 1)

		if not still_typing():
			print("> next_char")
			after()

	return get_active_char()


## Set [member char_idx] to the last letter of the active phrase such that [method still_typing] will resolve to [b]false[/b].
func stop_typing() -> void:
	set_active_char(len(get_active_phrase()) - 1)


## Set [member phrase_idx] to -1 (such that calling [method next] will return the first phrase).
func reset_talking() -> void:
	phrase_idx = -1
	reset_all()


## Set [member char_idx] to -1 (such that calling [method next] will return the first character).
func reset_typing() -> void:
	char_idx = -1


## Reset [member char_idx] and [member phrase_idx] to their default values.
## [br]See: [method reset_typing], [method reset_talking]
## [br][br] This will also reset all lifecycle events.
## [br]See: [method DialogueLifecycleEvents.reset_events]
func reset() -> void:
	reset_talking()
	reset_typing()

	reset_events()


# GETTERS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

## Get the phrase at [member phrase_index] of [member phrases].
func get_active_phrase() -> String:
	return phrases[phrase_idx]


## Get the character at [member char_idx] in the phrase at [member phrase_idx] of [member phrases].
func get_active_char() -> String:
	return get_active_phrase()[char_idx]


## Get a reference to a [Dialog] in [member next_dialogs].
func get_next_dialog(idx := 0) -> Dialog:
	return next_dialogs[idx]


## Get the [member option_name]s for all [Dialog]s in [member next_dialogs].
func get_option_names() -> Array:
	var names = []

	for dialog in next_dialogs:
		names.push_back(dialog.option_name)

	return names


# BUILDERS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

## Set [member speaker] and return self.
func set_speaker(name: String) -> Dialog:
	speaker = name
	return self


## Set [member phrases] and return self.
func set_phrases(texts: Array) -> Dialog:
	phrases = texts
	return self


## Set [member option_name] and return self.
func set_option_name(name: String) -> Dialog:
	option_name = name
	return self


## Set [member next_dialogs] and return self.
func set_next(dialogs: Array) -> Dialog:
	next_dialogs = dialogs
	return self


## Set [member using_typing] and return self.
func set_using_typing(using: bool) -> Dialog:
	using_typing = using
	return self


## Add a dialogue to the end of [member phrases] and return self.
func add_phrase(text: String) -> Dialog:
	phrases.push_back(text)
	return self


## Add a [Dialog] to the end of [member next_dialogs] and return self.
func add_next(dialog: Dialog) -> Dialog:
	next_dialogs.push_back(dialog)
	return self


## Create and return a [Dialog.Sequence] with this [Dialog] as the head of the Sequence.
func build_sequence(options := {}) -> Sequence:
	return Sequence.new(self, options)


## FOR THE FUTURE!!
# unsure if these are still issues:
# - options may pop up after dead sequence
# - sometimes it shows a blank screen when it should be a dead sequence


## Creates a form of linked-list using [Dialog]s to control the flow of a dialogue.
##
## [Dialog.Sequence] is a linked-list of [Dialog]s which manages the continuation of a dialogue
## and the propagation of "shared" properties (i.e., properties which might default to the previous
## [Dialog]'s). You may optionally provide lifecycle events, or a [Timer] to allow for a "typing" effect.
## [br][br]You should only ever need to consume the [Dialog.Sequence], as opposed to any [Dialog]s, directly.
## The only exception to this is for setting lifecycle events on [Dialog]s if you created the
## [Dialog.Sequence] using [method build].
class Sequence:
	extends DialogueLifecycleEvents

	## Cache for the first [Dialog] in the [Dialog.Sequence].
	var head: Dialog
	## The active [Dialog] in the [Dialog.Sequence].
	var dialog: Dialog = null
	## A [Timer] which controls the retrieval of the next char in the [Dialog.Sequence].
	var next_char_timer: Timer

	## Are [Dialog]s within the [Dialog.Sequence] allowed to use the typing effect?
	var allow_typing := true
	## Has the [Dialog.Sequence] not began?
	var cold := true
	## Has the [Dialog.Sequence] reached a dead end?
	var dead := false

	func _init(_head: Dialog, options := {}) -> void:
		head = head

		if "allow_typing" in options:
			allow_typing = options.allow_typing

		if "set_on_init" in options and options.set_on_init:
			set_dialog(head)


	## Build a [Dialog.Sequence] from a JSON-style config.
	## [br]Usage:
	## 		[codeblock]
	##		# all keys inside this config beginning with an underscore are arbitrary
	##		var config = {
	##		    "_head": {  # this will be our start of the Sequence
	##		        "speaker": "Mr. Rogers",
	##		        "using_typing": true,
	##		        "phrases": ["foo", "bar"],
	##		        "next": ["_opt1", "_opt2"]
	##		    },
	##		    "_opt1": {
	##		        "option_name": "Say hello",
	##		        "phrases": ["hello, neighbor!"],
	##		        "next": ["_head"]  # loop back to the start of the Sequence
	##		    },
	##		    "_opt2": {
	##		        "option_name": "End the show",
	##		        "phrases": ["You've made this day a special day by just your being you."]
	##		        # no "next", therefore the Sequence will end after this Dialog
	##		    }
	##		}
	##
	##		var dialog_sequence = Dialog.Sequence.build(config, "_head")
	##		# ... setup lifecycle events ...
	##		dialog_sequence.begin_dialog()
	##		[/codeblock]
	static func build(config: Dictionary, _head: String, options := {}) -> Variant:
		var dialog_map = {}

		for name in config:
			var _dialog = Dialog.new()

			for field in config[name]:
				if field == "next":
					continue

				_dialog["set_%s" % field].call(config[name][field])

			dialog_map[name] = _dialog

		for name in dialog_map:
			if "next" in config[name]:
				for next_dialog in config[name].next:
					dialog_map[name].add_next(dialog_map[next_dialog])

		var dialog_sequence = dialog_map[_head].build_sequence(options)
		dialog_sequence.head = dialog_map[_head]

		return (
			{"dialogs": dialog_map, "sequence": dialog_sequence} if "return_objs" in options and options.return_objs else dialog_sequence
		)


	# PROXY FUNCs FOR CURRENT DIALOG >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	## Does the current active [Dialog] have at least one Dialog proceeding it?
	## [br]See: [method Dialog.has_next]
	func has_next() -> bool:
		return dialog.has_next()

	## Does the current active [Dialog] have at least two Dialogs proceeding it?
	## [br](i.e., will the next Dialog need to be selected from a set of options?)
	## [br]See: [method Dialog.has_options]
	func has_options() -> bool:
		return dialog.has_options()

	## Does the [member Dialog.speaker] still have more [member Dialog.phrases] to display?
	## [br]See: [method Dialog.still_talking]
	func still_talking() -> bool:
		return dialog.still_talking()

	## When [member Dialog.using_typing] is [b]true[/b], have all characters of the active phrase been displayed?
	## [br]See: [method Dialog.still_typing]
	func still_typing() -> bool:
		return dialog.still_typing()

	## Does the current active [Dialog] have the property [member Dialog.using_typing] set to [b]true[/b]?
	## [br]i.e., is this Dialog trying to use a typing "animation"
	func using_typing() -> bool:
		return dialog.using_typing

	## Get the option names for any next [Dialog]s.
	## [br]See: [method Dialog.get_option_names]
	func get_option_names() -> Array:
		return dialog.get_option_names()

	## Get the [member Dialog.speaker] name for the active [Dialog].
	func get_speaker() -> String:
		return dialog.speaker


	# SEQUENCE API >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	## Is the [Dialog.Sequence] ready for the user to choose the next [Dialog]?
	## [br]Resolves to [b]true[/b] if not [method Dialog.still_talking] and [method Dialog.has_options].
	func ready_for_options() -> bool:
		return not dialog.still_talking() and dialog.has_options()


	## Reset the [Dialog.Sequence] at the provided [member head].
	## [br]This will not begin the Sequence.
	func reset() -> void:
		dialog = null # to prevent any property propagation
		set_dialog(head)
		cold = true


	## Sets the [Timer] to be associated with typing individual characters.
	## [br]Not calling this function when a [Dialog] in your [Dialog.Sequence] has [member Dialog.using_typing] set to [b]true[/b] will throw an error!
	func set_char_timer(timer: Timer) -> void:
		next_char_timer = timer


	## Sets the active [Dialog] for the [Dialog.Sequence], reviving the Sequence if it was [member dead].
	## [br]This will give the Dialog the Sequence's lifecycle callbacks, meaning if you set a Dialog's lifecycle callbacks [i]after[/i] it is set as active, then you will overwrite the Sequence callbacks!
	## [br](NOTE: this exludes before_all, after_next, and after_options)
	## [br]See: [DialogueLifecycleEvents]
	## [br][br]This will also propagate the previous Dialog's [member Dialog.using_typing] and [member Dialog.speaker] properties if the Dialog being set does not have them.
	func set_dialog(new_dialog: Dialog) -> void:
		var _using_typing = false
		var _speaker = ""
		if dialog != null:
			_using_typing = dialog.using_typing
			_speaker = dialog.speaker

		# let the Dialog object manage calling the Sequence's lifecycle events
		# except for before_all, after_options, and after_next_dialog as
		# the Sequence will handle that for the Dialog
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
			. on_after_all(func():
				after_all(false)
				new_dialog.after_all()
				)
			. on_before_options(func():
				before_options(false)
				new_dialog.before_options()
				)
			. on_before_next(func():
				before_next_dialog(false)
				new_dialog.before_next_dialog()
				)
		)
		dialog.reset()
		reset_events()

		if _using_typing:
			dialog.using_typing = _using_typing  # propagate using_typing (only if true tho)
		if dialog.speaker == "":
			dialog.set_speaker(_speaker) # propagate speaker if next_dialog does not have one

		dead = false # revive the Sequence if dead

		if not allow_typing:
			dialog.using_typing = false

		before_all(false)
		dialog.before_all()


	## Begin the [Dialog.Sequence] starting at the provided [member head].
	## If a [member next_char_timer] was provided to the Sequence, this will start the timer.
	func begin_dialog() -> String:
		set_dialog(head)
		cold = false

		return next(!next_char_timer) # force resolve as bool whether it doesn't exist


	## Retrieve the next character or phrase in the [Dialog.Sequence], the full active phrase if [param should_skip_typing] is [b]true[/b], or an empty string if setting the next phrase to prepare for typing.
	## [br]Related: [method Dialog.next]
	func next(should_skip_typing := true) -> String:
		reset_events()

		if dialog.using_typing and dialog.still_typing():
			return _handle_typing(should_skip_typing)

		print(dialog.phrase_idx)
		if dialog.still_talking():
			return _handle_still_talking()

		return _handle_not_talking()


	## Choose a [Dialog] from the active Dialog's [member Dialog.next_dialogs] array.
	## [br]If [member Dialog.using_typing] is [b]true[/b], this will start the [member next_char_timer] and return an empty string to prepare for typing.
	func choose_option(idx: int) -> String:
		if dialog.using_typing:
			_next_dialog(idx)  # start next Dialog and set first phrase as active
			next_char_timer.start()
			return ""  # clear the previous phrase to prep. for typing

		return _next_dialog(idx)  # no more phrases, so start next Dialog and return the first phrase


	# INTERNAL >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	# Handle the case in next() when using_typing and still_typing.
	func _handle_typing(should_skip_typing: bool) -> String:
		var _next = dialog.next(should_skip_typing)

		if should_skip_typing or not dialog.still_typing():
			next_char_timer.stop()

		return _next


	# Handle the case in next() when using_typing or still_typing are false and still_talking is true.
	func _handle_still_talking() -> String:
		if dialog.using_typing:
			dialog.next()  # set next phrase as active
			next_char_timer.start()
			return ""  # clear the previous phrase to prep. for typing

		return dialog.next()  # next_phrase


	# Handle the case in next() when (using_typing or still_typing) and still_talking are false.
	func _handle_not_talking() -> String:
		if not dialog.has_next():  # i.e., no Dialogs next (end of sequence)
			dead = true
			return ""  # to avoid unnecessary Nil errors

		if not dialog.has_options():  # i.e., only one Dialog next (no option)
			return choose_option(0)

		return dialog.get_active_phrase()  # resend curr_phrase (waiting for an option to be selected)


	# Set the next dialog and call lifecycle events as appropriate.
	func _next_dialog(idx := 0) -> String:
		var _had_next = dialog.has_next()
		var _after_next = dialog.after_next_dialog
		var _had_options = dialog.has_options()
		var _after_options = dialog.after_options

		set_dialog(dialog.get_next_dialog(idx))

		if _had_next:
			after_next_dialog(false)
			_after_next.call()
		if _had_options:
			after_options(false)
			_after_options.call()

		# sets first phrase of the new Dialog as active
		return next()  # val returned is either the first phrase or the first char
