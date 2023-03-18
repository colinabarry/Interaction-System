# class_name Dialog

# var dialog: Dialog

# var speakers := [] #<String>
# var option_name := ""
# var phrase_idx := -1
# var char_idx := -1
# var phrases := []  #<String>
# var next_dialogs := []  #<Dialog>
# var using_typing := false # this will be passed to proceeding Dialogs

# var dead := false

# var _before_each := func():
# 	return
# var _after_each := func():
# 	return
# var _before_all := func():
# 	return
# var _after_all := func():
# 	return
# var _before_next_dialog := func():
# 	return
# var _after_next_dialog := func():
# 	return

# ## Runs before active_text is updated
# var before_each := func():
# 	_before_each.call()
# ## Runs after active_text is updated and after the full text is written to the scene
# var after_each := func():
# 	_after_each.call()
# ## Runs when this Dialog object is selected or when active_text is set to 0
# var before_all := func():
# 	_before_all.call()
# ## Runs after the last _base_texts element is written to the scene
# var after_all := func():
# 	_after_all.call()
# ## Runs before set of next_dialog options are displayed on the screen.
# ## You must have at least two elements in _next_dialogs for this to run.
# var before_next_dialog := func():
# 	if next_dialogs.size() < 2: 
# 		return
# 	_before_next_dialog.call()
# ## Runs after the next_dialog option has been selected
# ## You must have at least two elements in _next_dialogs for this to run.
# var after_next_dialog := func():
# 	if next_dialogs.size() < 2: 
# 		return
# 	_after_next_dialog.call()


# func _init(base = [], option = ""):
# 	phrases = base
# 	option_name = option


# # PREFERRED EXTERNAL API

# func set_dialog(new_dialog: Dialog):
# 	dialog = new_dialog
# 	dialog.reset()
# 	dialog.dead = false

# func next(idx: int = -1):
# 	# maybe don't need
# 	if dialog.dead:
# 		return

# 	char_idx = -1;

# 	if idx != -1:
# 		dialog = dialog.get_next_dialog(idx)
# 		dialog.reset()
# 		return next()

# 	if dialog.phrase_idx == -1:
# 		dialog.before_all.call()

# 	if dialog.still_talking():
# 		dialog.before_each.call()
# 		dialog.next()
# 		return dialog.get_active()

# 	if not dialog.has_next():
# 		dead = true
# 		return ''

# 	if not dialog.has_options():
# 		print("doesn't have options")
# 		dialog = dialog.get_next_dialog(0)
# 		dialog.reset()
# 		return next()

# 	return dialog.get_active()


# # BOOL STUFF

# func has_next():
# 	return next_dialogs.size() > 0

# func has_options():
# 	return next_dialogs.size() > 1

# func still_talking():
# 	return phrase_idx < phrases.size() - 1

# func is_typing():
# 	return char_idx < len(get_active_phrase()) - 1

# # LINKED-LISTY STUFF
# # CHANGING INDICES, CONSIDER AS HELPERS

# func set_active_phrase(idx: int):
# 	phrase_idx = idx % phrases.size()

# func next_phrase():
# 	if phrase_idx == phrases.size():
# 		return
# 	set_active_phrase(phrase_idx + 1)

# func prev_phrase():
# 	if phrase_idx == 0:
# 		return
# 	set_active_phrase(phrase_idx - 1)

# func reset():
# 	set_active_phrase(-1)

# func next_char():
# 	char_idx += 1

# func stop_typing():
# 	char_idx = len(get_active_phrase()) - 1

# # GETTERS

# func get_active_phrase():
# 	return phrases[phrase_idx]

# func get_next_dialog(idx: int):
# 	return next_dialogs[idx]

# func get_option_names():
# 	var names = []
# 	for _dialog in next_dialogs:
# 		names.push_back(_dialog.option_name)

# 	return names


# #==========
# # BUILDERS
# #=========

# # PROPERTIES

# ## Set the names of the speakers for this Dialog object.
# ## Returns self for builder pattern.
# func set_speakers(names: Array):
# 	speakers = names
# 	return self

# ## Set the dialogues for this Dialog object.
# ## Returns self for builder pattern.
# func set_base(texts: Array):
# 	phrases = texts
# 	return self

# ## Set the option name for this Dialog object that will be used when this object is one of many potential next Dialogs.
# ## Returns self for builder pattern.
# func set_option_name(name: String):
# 	option_name = name
# 	return self

# ## Set the Dialog objects which can come after this Dialog object finishes iterating through its dialogues.
# ## Returns self for builder pattern.
# func set_next(dialogs: Array):
# 	next_dialogs = dialogs
# 	return self

# ## Add a speaker name to the end of this Dialog object's list of speakers. 
# ## Returns self for builder pattern.
# func add_speaker(name: String):
# 	speakers.push_back(name);

# ## Add a dialogue to the end of this Dialog object's list of dialogues
# ## Returns self for builder pattern.
# func add_base(text: String):
# 	phrases.push_back(text)
# 	return self

# ## Add a Dialog object to the end of this Dialog object's list of next Dialogs.
# ## Returns self for builder pattern.
# func add_next(dialog: Dialog):
# 	next_dialogs.push_back(dialog)
# 	return self

# # "events"
# func on_before_each(fn):
# 	_before_each = fn
# 	return self

# func on_after_each(fn):
# 	_after_each = fn
# 	return self

# func on_before_all(fn):
# 	_before_all = fn
# 	return self

# func on_after_all(fn):
# 	_after_all = fn
# 	return self

# func on_before_next(fn):
# 	_before_next_dialog = fn
# 	return self

# func on_after_next(fn):
# 	_after_next_dialog = fn
# 	return self

# # fin building
# func build_sequence():
# 	return Sequence.new(self)

