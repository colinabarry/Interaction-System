class_name DialogueLifecycleEvents

## Callback container for the before_each function.
## This is not intended to be called directly.
var _before_each := func():
	return
## Callback container for the after_each function.
## This is not intended to be called directly.
var _after_each := func():
	return
## Callback container for the before_all function.
## This is not intended to be called directly.
var _before_all := func():
	return
## Callback container for the after_all function.
## This is not intended to be called directly.
var _after_all := func():
	return
## Callback container for the before_next_dialog function.
## This is not intended to be called directly.
var _before_next_dialog := func():
	return
## Callback container for the after_next_dialog function.
## This is not intended to be called directly.
var _after_next_dialog := func():
	return


# make sure each callback only runs one time when it's supposed to
var before_each_ran := false
var after_each_ran := false
var before_all_ran := false
var after_all_ran := false
var before_next_ran := false
var after_next_ran := false

## Runs before the active phrase is updated.
func before_each(print_name := true):
	if before_each_ran:
		return

	if print_name:
		print("before_each")

	before_each_ran = true
	_before_each.call()

## Runs after the active phrase is updated and the full text is displayed.
func after_each(print_name := true):
	if after_each_ran:
		return

	if print_name:
		print("after_each")

	after_each_ran = true
	_after_each.call()

## Runs when this Dialog object is selected or when the active phrase index is set to 0.
func before_all(print_name := true):
	if before_all_ran:
		return

	if print_name:
		print("before_all")

	before_all_ran = true
	_before_all.call()

## Runs after the last phrase is updated and the full text is displayed.
func after_all(print_name := true):
	if after_all_ran:
		return

	if print_name:
		print("after_all")

	after_all_ran = true
	_after_all.call()

## Runs before the set of options (next_dialogs) are displayed.
## You must have at least two elements in next_dialogs for this to run.
func before_next_dialog(print_name := true):
	if before_next_ran:
		return

	if print_name:
		print("before_next_dialog")

	before_next_ran = true
	_before_next_dialog.call()

## Runs after an option (next_dialog) has been selected.
## You must have at least two elements in next_dialogs for this to run.
func after_next_dialog(print_name := true):
	if after_next_ran:
		return

	if print_name:
		print("after_next_dialog")

	after_next_ran = true
	_after_next_dialog.call()


## Allow before_each and after_each to run again.
func reset_each():
	before_each_ran = false
	after_each_ran = false

## Allow before_all and after_all to run again.
func reset_all():
	before_all_ran = false
	after_all_ran = false

## Allow before_next_dialog and after_next_dialog to run again.
func reset_next():
	before_next_ran = false
	after_next_ran = false


# SET THE CALLBACKS

## Callback that will run before the active phrase is updated.
## Returns self.
func on_before_each(fn: Callable) -> DialogueLifecycleEvents:
	_before_each = fn
	return self


## Callback that will run after the active phrase is updated and after the full text is displayed.
## Returns self.
func on_after_each(fn: Callable) -> DialogueLifecycleEvents:
	_after_each = fn
	return self


## Callback that will run when this Dialog object is selected or when the active phrase index is set to 0.
## Returns self.
func on_before_all(fn: Callable) -> DialogueLifecycleEvents:
	_before_all = fn
	return self


## Callback that will run after the last phrase is updated and after the full text is displayed.
## Returns self.
func on_after_all(fn: Callable) -> DialogueLifecycleEvents:
	_after_all = fn
	return self


## Callback that will run before the set of options (next_dialogs) are displayed.
## You must have at least two elements in next_dialogs for this to run.
## Returns self.
func on_before_next(fn: Callable) -> DialogueLifecycleEvents:
	_before_next_dialog = fn
	return self


## Callback that will run after an option (next_dialog) has been selected.
## You must have at least two elements in next_dialogs for this to run.
## Returns self.
func on_after_next(fn: Callable) -> DialogueLifecycleEvents:
	_after_next_dialog = fn
	return self
