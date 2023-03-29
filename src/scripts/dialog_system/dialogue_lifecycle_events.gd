class_name DialogueLifecycleEvents
## Convenience class to abstract away dialogue-based lifecycle event implementations.
##
## This class is not intended to be used directly, only inherited.
## [br]Use the on_xxx methods to provide lifecycle dependent callbacks.
## [br]Use the xxx methods to call the events when appropriate.


## Callback container for [method before_each].
## [br]This is not intended to be called directly.
var _before_each_ := func(): return
## Callback container for [method after_each].
## [br]This is not intended to be called directly.
var _after_each_ := func(): return
## Callback container for [method before_all].
## [br]This is not intended to be called directly.
var _before_all_ := func(): return
## Callback container for [method after_all].
## [br]This is not intended to be called directly.
var _after_all_ := func(): return
## Callback container for [method before_next_dialog].
## [br]This is not intended to be called directly.
var _before_next_dialog_ := func(): return
## Callback container for [method after_next_dialog].
## [br]This is not intended to be called directly.
var _after_next_dialog_ := func(): return
## Callback container for [method before_options].
## [br]This is not intended to be called directly.
var _before_options_ := func(): return
## Callback container for [method after_options].
## [br]This is not intended to be called directly.
var _after_options_ := func(): return


# SENTINELS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# make sure each callback only runs one time when it's supposed to
var _before_each_ran := false
var _after_each_ran := false
var _before_all_ran := false
var _after_all_ran := false
var _before_next_ran := false
var _after_next_ran := false
var _before_options_ran := false
var _after_options_ran := false


# CALL THE CALLBACKS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

## Runs before the active phrase of [member Dialog.phrases] is updated.
func before_each(print_name := true) -> void:
	if _before_each_ran:
		return

	if print_name:
		print("before_each")

	_before_each_ran = true
	_before_each_.call()


## Runs after the active phrase of [member Dialog.phrases] is updated and the full text is displayed.
func after_each(print_name := true) -> void:
	if _after_each_ran:
		return

	if print_name:
		print("after_each")

	_after_each_ran = true
	_after_each_.call()


## Runs when a [Dialog] is set in a [Dialog.Sequence].
func before_all(print_name := true) -> void:
	if _before_all_ran:
		return

	if print_name:
		print("before_all")

	_before_all_ran = true
	_before_all_.call()


## Runs after the last phrase in [member Dialog.phrases] is updated and the full text is displayed.
func after_all(print_name := true) -> void:
	if _after_all_ran:
		return

	if print_name:
		print("after_all")

	_after_all_ran = true
	_after_all_.call()


## Runs before the [Dialog.Sequence] sets the next [Dialog].
## [br]You must have at least one element in [member Dialog.next_dialogs] for this to run.
func before_next_dialog(print_name := true) -> void:
	if _before_next_ran:
		return

	if print_name:
		print("before_next_dialog")

	_before_next_ran = true
	_before_next_dialog_.call()


## Runs after the [Dialog.Sequence] sets the next [Dialog].
## [br]You must have at least one element in [member Dialog.next_dialogs] for this to run.
func after_next_dialog(print_name := true) -> void:
	if _after_next_ran:
		return

	if print_name:
		print("after_next_dialog")

	_after_next_ran = true
	_after_next_dialog_.call()


## Runs when the set of options are ready to be displayed.
## [br]You must have at least two elements in [member Dialog.next_dialogs] for this to run.
func before_options(print_name := true) -> void:
	if _before_options_ran:
		return

	if print_name:
		print("before_options")

	_before_options_ran = true
	_before_options_.call()


## Runs after an option has been selected and the [Dialog.Sequence] sets the new [Dialog].
## You must have at least two elements in [member Dialog.next_dialogs] for this to run.
func after_options(print_name := true) -> void:
	if _after_options_ran:
		return

	if print_name:
		print("after_options")

	_after_options_ran = true
	_after_options_.call()


## Allow [method before_each] and [method after_each] to run again.
func reset_each() -> void:
	_before_each_ran = false
	_after_each_ran = false


## Allow [method before_all] and [method after_all] to run again.
func reset_all() -> void:
	_before_all_ran = false
	_after_all_ran = false


## Allow [method before_next_dialog] and [method after_next_dialog] to run again.
func reset_next() -> void:
	_before_next_ran = false
	_after_next_ran = false


## Allow [method before_options] and [method after_options] to run again.
func reset_options() -> void:
	_before_options_ran = false
	_after_options_ran = false


## Allow all lifecycle events to run again.
func reset_events() -> void:
	reset_each()
	reset_all()
	reset_next()
	reset_options()


# SET THE CALLBACKS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

## Provide a callback that will run before the active phrase of [member Dialog.phrases] is updated.
## [br]Returns self.
func on_before_each(fn: Callable) -> DialogueLifecycleEvents:
	_before_each_ = fn
	return self


## Provide a callback that will run after the active phrase of [member Dialog.phrases] is updated and the full text is displayed.
## [br]Returns self.
func on_after_each(fn: Callable) -> DialogueLifecycleEvents:
	_after_each_ = fn
	return self


## Provide a callback that will run when a [Dialog] is set in a [Dialog.Sequence].
## [br]i.e., before the first phrase of [member Dialog.phrases] is displayed.
## [br]Returns self.
func on_before_all(fn: Callable) -> DialogueLifecycleEvents:
	_before_all_ = fn
	return self


## Provide a callback that will run after the last phrase in [member Dialog.phrases] is updated and the full text is displayed.
## [br]Returns self.
func on_after_all(fn: Callable) -> DialogueLifecycleEvents:
	_after_all_ = fn
	return self


## Provide a callback that will run before the [Dialog.Sequence] sets the next [Dialog].
## [br]You must have at least one element in [member Dialog.next_dialogs] for this to run.
## [br]Returns self.
func on_before_next(fn: Callable) -> DialogueLifecycleEvents:
	_before_next_dialog_ = fn
	return self


## Provide a callback that will run after the [Dialog.Sequence] sets the next [Dialog].
## [br]You must have at least one element in [member Dialog.next_dialogs] for this to run.
## [br]Returns self.
func on_after_next(fn: Callable) -> DialogueLifecycleEvents:
	_after_next_dialog_ = fn
	return self


## Provide a callback that will run when the set of options are ready to be displayed.
## [br]You must have at least two elements in [member Dialog.next_dialogs] for this to run.
## [br]Returns self.
func on_before_options(fn: Callable) -> DialogueLifecycleEvents:
	_before_options_ = fn
	return self


## Provide a callback that will run after an option has been selected and the [Dialog.Sequence] sets the new [Dialog].
## [br]You must have at least two elements in [member Dialog.next_dialogs] for this to run.
## [br]Returns self.
func on_after_options(fn: Callable) -> DialogueLifecycleEvents:
	_after_options_ = fn
	return self
