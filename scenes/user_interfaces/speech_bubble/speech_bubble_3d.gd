@tool
extends DialogueSystem

@export var tween_time := 1


func _ready():
	self.modulate = Color.TRANSPARENT
	super()


func _on_seq_before_all():
	super()
	await Global.tween_cubic_modulate(self, Color.WHITE, tween_time).finished


func _on_seq_after_all():
	await Global.tween_cubic_modulate(self, Color.TRANSPARENT, tween_time).finished
	super()
