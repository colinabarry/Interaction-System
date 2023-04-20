extends Node

var _modulate


func _init():
	_modulate = self.modulate
	self.modulate = Color.TRANSPARENT


func _ready():
	Global.tween_cubic_modulate(self, _modulate)


func _on_start_pressed():
	await Global.tween_cubic_modulate(self).finished

	get_tree().change_scene_to_file("res://scenes/levels/overworld/SandboxOverworld.tscn")


func _on_quit_pressed():
	get_tree().quit()
