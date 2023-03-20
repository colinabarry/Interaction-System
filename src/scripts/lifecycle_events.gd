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

## Runs before the active phrase is updated.
var before_each := func():
	_before_each.call()

## Runs after the active phrase is updated and after the full text is displayed.
var after_each := func():
	_after_each.call()

## Runs when this Dialog object is selected or when the active phrase index is set to 0.
var before_all := func():
	_before_all.call()

## Runs after the last phrase is updated and after the full text is displayed.
var after_all := func():
	_after_all.call()

## Runs before the set of options (next_dialogs) are displayed.
## You must have at least two elements in next_dialogs for this to run.
var before_next_dialog := func():
	_before_next_dialog.call()

## Runs after an option (next_dialog) has been selected.
## You must have at least two elements in next_dialogs for this to run.
var after_next_dialog := func():
	_after_next_dialog.call()




# "events"


## Callback that will run before the active phrase is updated.
## Returns self.
func on_before_each(fn: Callable) -> Dialog:
	_before_each = fn
	return self


## Callback that will run after the active phrase is updated and after the full text is displayed.
## Returns self.
func on_after_each(fn: Callable) -> Dialog:
	_after_each = fn
	return self


## Callback that will run when this Dialog object is selected or when the active phrase index is set to 0.
## Returns self.
func on_before_all(fn: Callable) -> Dialog:
	_before_all = fn
	return self


## Callback that will run after the last phrase is updated and after the full text is displayed.
## Returns self.
func on_after_all(fn: Callable) -> Dialog:
	_after_all = fn
	return self


## Callback that will run before the set of options (next_dialogs) are displayed.
## You must have at least two elements in next_dialogs for this to run.
## Returns self.
func on_before_next(fn: Callable) -> Dialog:
	_before_next_dialog = fn
	return self


## Callback that will run after an option (next_dialog) has been selected.
## You must have at least two elements in next_dialogs for this to run.
## Returns self.
func on_after_next(fn: Callable) -> Dialog:
	_after_next_dialog = fn
	return self