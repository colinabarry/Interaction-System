extends Node

var tween_time := 1
var _modulate


func _init():
	_modulate = self.modulate
	self.modulate = Color.TRANSPARENT


func _ready():
	tween_cubic_modulate(_modulate, tween_time)


func _on_start_pressed():
	pass  # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()


func tween_cubic_modulate(color: Color, time: int) -> PropertyTweener:
	return create_tween().set_trans(Tween.TRANS_CUBIC).tween_property(self, "modulate", color, time)
