@tool
extends DialogueSystem

@export var tween_time := 1


func _ready():
	self.modulate = Color.TRANSPARENT
	super()


func _on_seq_before_all():
	super()
	await tween_cubic_modulate(Color.WHITE, tween_time).finished


func _on_seq_after_all():
	await tween_cubic_modulate(Color.TRANSPARENT, tween_time).finished
	super()


func tween_cubic_modulate(color: Color, time: int) -> PropertyTweener:
	return create_tween().set_trans(Tween.TRANS_CUBIC).tween_property(self, "modulate", color, time)
