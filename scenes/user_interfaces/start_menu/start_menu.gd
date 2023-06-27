extends Node

var _modulate


func _init():
	_modulate = self.modulate
	self.modulate = Color.TRANSPARENT


func _ready():
	Global.tween_cubic_modulate(self, _modulate)
	Global.reset_progress_state()
	Global.transition_rect.fade_in()

var scene = preload("res://scenes/levels/overworld/sandboxoverworld.tscn").instantiate()
func _on_start_pressed():
	Global.transition_rect.fade_out(1)
	await Global.tween_cubic_modulate(self).finished

	get_tree().change_scene_to_packed(scene)


func _on_quit_pressed():
	get_tree().quit()


func _on_start_2_pressed() -> void:
	Global.transition_rect.fade_out()
	await Global.transition_rect.faded_out
	get_tree().change_scene_to_file("scenes/user_interfaces/credits.tscn")
