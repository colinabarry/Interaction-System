class_name TransitionArea extends ColorRect

signal faded_out
signal faded_in

## Fade over specified time to specified color from transparent
func fade_out(fade_time := 1.0, start_color := Color.BLACK, end_color := Color.BLACK) -> bool:
	if visible == true and modulate != Color.TRANSPARENT:
		return false

	visible = true
	color = start_color

	var fade_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC)
	fade_tween.tween_property(self, "modulate", Color.WHITE, fade_time)

	if start_color != end_color:
		fade_tween.tween_property(self, "color", end_color, fade_time)

	await fade_tween.finished
	faded_out.emit()

	return true


## Fade over specified time to transparent specified color from last color
func fade_in(fade_time := 1.0, end_color := Color.BLACK) -> bool:
	print("Fade in called from rect_transition")
	if visible == false and modulate == Color.TRANSPARENT:
		print("Fade in failed")
		return false

	var fade_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC)
	fade_tween.tween_property(self, "modulate", Color.TRANSPARENT, fade_time)

	if color != end_color:
		fade_tween.tween_property(self, "color", end_color, fade_time)

	await fade_tween.finished
	faded_in.emit()
	visible = false
	print("Fade in success")
	return true
