class_name EventManager
## Convenience class for creating batches of user [Signal]s that can optionally be fired only once.
##
## This class is not intended to be used directly, only inherited from.
## Any [Signal]s you want to create should be defined in the [method _init] method by name.
## [br]To connect to a [Signal] you [b]must[/b] use the [Object] syntax, e.g., [code]connect("signal_name", Callable)[/code].
## [br]To emit a [Signal] you can either use the [method emit_once] method or the [method emit_signal] method.
## If you use [method emit_once], then the [Signal] will only be emitted once, and you will need to call [method reset_group] or [method reset_signal]
## to allow it to be emitted again.
## [br]If you use [method emit_signal], then the [Signal] will be emitted every time it is called, even if it is currently blocked for [method emit_once].
## [br]To group [Signal]s to make resetting easier, you can use the underscore character to separate the [Signal] name from the group name ("signal_group"),
## e.g., [code]"before_each"[/code] and [code]"after_each"[/code] are in the [code]"each"[/code] group.
## [br]A [Signal] can belong to any number of groups, just add more delimited by underscores, e.g., [code]"signal_group1_group2_etc"[/code].
## [br]For more complex behavior with groups, see [method reset_group].
## [br][br]Related: [method add_user_signal], [method emit_signal], [method Object.connect]

# all "signals", each with an "emitted" bool and an "emit" method
var _signals := {}
# maps group names to signal names
var _group_map := {}

## The names of the [Signal]s that must be reset using [method reset_signal] with [param partial] set to false.
var must_reset_explicitly := []


func _init(signal_names: Array, store_signal_name_without_groups := true, log_emits := false) -> void:
	for name in signal_names:
		add_user_signal(name)

		var group_names = name.split("_")
		var isolated_name = group_names[0]
		group_names = group_names.slice(1)

		if store_signal_name_without_groups:
			name = isolated_name

		_signals[name] = {
			"emitted": false,
			"emit": func():
				if _signals[name].emitted:
					return false

				if log_emits:
					print("EMIT> %s" % name)

				emit_signal(name)
				_signals[name].emitted = true

				return true
		}

		for group_name in group_names:
			if group_name in _group_map:
				_group_map[group_name].append(name)
			else:
				_group_map[group_name] = [name]


## Emit the signal with the given [param signal_name] if it hasn't been emitted yet.
## [br]Returns a bool representing whether or not the [Signal] was emitted successfully.
## [br]To be used in place of [method emit_signal] when you want to make sure a signal is only emitted once.
## [br]Call [method reset] with the same [param signal_name] to allow the signal to be emitted again.
func emit_once(signal_name: String) -> bool:
	if signal_name in _signals:
		return _signals[signal_name].emit.call()

	return false


## Reset the [Signal] group with the given [param name] so that it can be emitted again.
## [br]If [param partial] is true, then the [param name] only needs to partially match to reset a given [Signal] group.
## [br]A [Signal] group is denoted by the last part of a [Signal]'s name, separated by an underscore. e.g., the [Signal] "before_each" is in the "each" group.
## A [Signal] can belong to any number of groups, just add more delimited by underscores, e.g., "signal_group1_group2_etc".
## [br]The [param name] can be an [Array] for special behavior:
## [br]If [param name] is an [Array] and partial is true, then it will reset each group provided in the [Array] separately.
## [br]If [param name] is an [Array] and partial is false, then it will reset only [Signal]s which are in all groups in [param name].
## [br]NOTE: The [param name] "events" is reserved. It will reset all [Signal]s for this instance.
func reset_group(name: Variant, partial := false) -> void:
	if name is Array:
		if partial:
			for group_name in name:
				reset_group(group_name, false)
			return
		else:
			var fake_set := _signals.duplicate()
			for group_name in name:
				for entry in fake_set:
					if entry not in _group_map[group_name] or entry in must_reset_explicitly:
						fake_set.erase(entry)

			for entry in fake_set:
				reset_signal(entry, false)

	if partial:
		for group_name in _group_map:
			if name in group_name:
				_guarded_reset_signals(_group_map[group_name])
	else:
		if name == "events":
			_guarded_reset_signals(_signals)

		if name in _group_map:
			_guarded_reset_signals(_group_map[name])


## Reset the [Signal] with the given [param name] so that it can be emitted again.
## [br]If [param partial] is true, then the [param name] only needs to partially match to reset a given [Signal].
func reset_signal(name: String, partial := false) -> void:
	if partial:
		_guarded_reset_signals(_signals, true, name)
	elif name in _signals:
		_signals[name].emitted = false


# Ensure that [method reset_group], and [method reset_signal] when [param partial] is true, don't reset signals that must be reset explicitly.
func _guarded_reset_signals(signals: Variant, partial := false, name := "") -> void:
	for signal_name in signals:
		if partial and name not in signal_name:
			continue

		if signal_name in must_reset_explicitly:
			continue

		_signals[signal_name].emitted = false


# ORIGINAL SIGNAL IMPLEMENTATION >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# signal before_each
# signal after_each
# signal before_all
# signal after_all
# signal before_next
# signal after_next
# signal before_options
# signal after_options

# # SENTINELS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# # make sure each callback only runs one time when it's supposed to
# var _before_each_ran_ := false
# var _after_each_ran_ := false
# var _before_all_ran_ := false
# var _after_all_ran_ := false
# var _before_next_ran_ := false
# var _after_next_ran_ := false
# var _before_options_ran_ := false
# var _after_options_ran_ := false


# func reset_each() -> void:
# 	_before_each_ran_ = false
# 	_after_each_ran_ = false


# func reset_all() -> void:
# 	_before_all_ran_ = false
# 	_after_all_ran_ = false


# func reset_next() -> void:
# 	_before_next_ran_ = false
# 	_after_next_ran_ = false


# func reset_options() -> void:
# 	_before_options_ran_ = false
# 	_after_options_ran_ = false


# func reset_events() -> void:
# 	reset_each()
# 	reset_all()
# 	reset_next()
# 	reset_options()


# # GUARDED EMITTERS >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


# func emit_before_each() -> void:
# 	if _before_each_ran_:
# 		return

# 	if log_emits:
# 		print("EMIT> before_each")

# 	before_each.emit()
# 	_before_each_ran_ = true


# func emit_after_each() -> void:
# 	if _after_each_ran_:
# 		return

# 	if log_emits:
# 		print("EMIT> after_each")

# 	after_each.emit()
# 	_after_each_ran_ = true


# func emit_before_all() -> void:
# 	if _before_all_ran_:
# 		return

# 	if log_emits:
# 		print("EMIT> before_all")

# 	before_all.emit()
# 	_before_all_ran_ = true


# func emit_after_all() -> void:
# 	if _after_all_ran_:
# 		return

# 	if log_emits:
# 		print("EMIT> after_all")

# 	after_all.emit()
# 	_after_all_ran_ = true


# func emit_before_next() -> void:
# 	if _before_next_ran_:
# 		return

# 	if log_emits:
# 		print("EMIT> before_next")

# 	before_next.emit()
# 	_before_next_ran_ = true


# func emit_after_next() -> void:
# 	if _after_next_ran_:
# 		return

# 	if log_emits:
# 		print("EMIT> after_next")

# 	after_next.emit()
# 	_after_next_ran_ = true


# func emit_before_options() -> void:
# 	if _before_options_ran_:
# 		return

# 	if log_emits:
# 		print("EMIT> before_options")

# 	before_options.emit()
# 	_before_options_ran_ = true


# func emit_after_options() -> void:
# 	if _after_options_ran_:
# 		return

# 	if log_emits:
# 		print("EMIT> after_options")

# 	after_options.emit()
# 	_after_options_ran_ = true
